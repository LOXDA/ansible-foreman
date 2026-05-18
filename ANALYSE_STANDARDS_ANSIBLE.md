# Analyse de conformité aux standards Ansible

Date: 18/05/2026
Branche: ansible-standards-analysis

## Problèmes identifiés et corrections proposées

### 1. Configuration Ansible (ansible.cfg)

**Problème actuel:**
```ini
deprecation_warnings = false
```

**Problème:** Les avertissements de dépréciation sont désactivés, ce qui empêche de détecter les pratiques obsolètes.

**Correction proposée:**
```ini
deprecation_warnings = true
```

**Justification:** Permet de maintenir le code à jour avec les meilleures pratiques Ansible et d'anticiper les changements futurs.

### 2. Playbook deploy_certificates.yml

**Problèmes identifiés:**

a) **Ligne commentée inutile:**
```yaml
# - hosts: "{{ target | default('all') }}"
```

b) **Utilisation de shell au lieu de modules Ansible:**
```yaml
- name: Update ca-certificates
  ansible.builtin.shell: |
    update-ca-certificates
```

c) **Absence de gestion d'erreurs et handlers**

d) **Absence de valeurs par défaut pour les variables**

e) **Absence de nom pour le playbook**

**Version corrigée proposée:**

```yaml
---
- name: Déploiement de la configuration des certificats
  hosts: all
  gather_facts: true
  become: true

  tasks:
    - name: S'assurer que le paquet ca-certificates est installé
      ansible.builtin.apt:
        name: ca-certificates
        state: present
        update_cache: yes

    - name: Déployer les certificats CA personnalisés
      ansible.builtin.copy:
        dest: "/usr/local/share/ca-certificates/{{ item.name | basename }}"
        content: "{{ item.filecontent }}"
        owner: root
        group: root
        mode: 0644
      loop: "{{ vault_ca_certs_files | default([]) }}"
      notify: mettre à jour les certificats ca
      when: vault_ca_certs_files is defined

  handlers:
    - name: mettre à jour les certificats ca
      ansible.builtin.command: update-ca-certificates
      changed_when: false
      args:
        warn: false
```

### 3. Problèmes généraux dans les playbooks

**Problèmes identifiés:**

a) **Lignes commentées inutiles:**
- Plusieurs playbooks contiennent des lignes commentées qui semblent être des anciens codes ou des notes
- Exemple dans deploy_foreman.yml: lignes 9-15 commentées

b) **Utilisation de tags "never":**
- Certains playbooks utilisent le tag "never" qui peut prêter à confusion
- Exemple dans deploy_dns.yml: tags never + monitoring

c) **Absence de noms de playbook:**
- La plupart des playbooks n'ont pas de champ "name" au niveau du playbook

### 4. Bonnes pratiques identifiées

**Points positifs:**

a) **Utilisation de modules Ansible:**
- Bonne utilisation de `ansible.builtin.apt` et `ansible.builtin.copy`

b) **Structure modulaire:**
- Utilisation de `import_playbook` pour organiser le code
- Utilisation de rôles pour une meilleure organisation

c) **Gestion des collections:**
- Fichier requirements.yml bien structuré avec les collections nécessaires

### 5. Recommandations générales

**Standards à appliquer:**

1. **Nommage:**
   - Utiliser des noms de playbook clairs et descriptifs
   - Utiliser des noms de tâches explicites (verbes à l'infinitif)

2. **Modules:**
   - Privilégier les modules Ansible plutôt que les commandes shell
   - Utiliser `ansible.builtin.command` plutôt que `shell` quand possible

3. **Handlers:**
   - Utiliser des handlers pour les opérations idempotentes
   - Définir `changed_when: false` pour les commandes qui ne changent pas l'état

4. **Gestion des erreurs:**
   - Ajouter des conditions `when` pour éviter les échecs
   - Utiliser des valeurs par défaut avec `| default([])` ou `| default({})`

5. **Documentation:**
   - Nettoyer les lignes commentées inutiles
   - Documenter les choix de conception dans des commentaires clairs
   - Expliquer l'usage des tags "never" dans des commentaires

6. **Structure:**
   - Ajouter un champ "name" à chaque playbook
   - Organiser les tâches par thème avec des commentaires
   - Utiliser des tags de manière cohérente

### 6. Outils recommandés

**Pour améliorer la qualité du code:**

1. **ansible-lint:**
   ```bash
   pip install ansible-lint
   ansible-lint playbooks/
   ```

2. **Molecule:**
   - Pour tester les rôles de manière isolée

3. **Pre-commit hooks:**
   - Configurer des hooks pour exécuter ansible-lint avant chaque commit

### 7. Plan d'action recommandé

**Étapes pour améliorer la conformité:**

1. **Phase 1 - Configuration:**
   - Activer les avertissements de dépréciation dans ansible.cfg
   - Installer et configurer ansible-lint

2. **Phase 2 - Nettoyage:**
   - Supprimer les lignes commentées inutiles
   - Documenter les commentaires nécessaires
   - Ajouter des noms aux playbooks

3. **Phase 3 - Correction:**
   - Remplacer shell par des modules Ansible appropriés
   - Ajouter des handlers et gestion d'erreurs
   - Appliquer des valeurs par défaut aux variables

4. **Phase 4 - Validation:**
   - Exécuter ansible-lint sur tous les playbooks
   - Tester les playbooks modifiés
   - Documenter les changements

## Conclusion

Le code Ansible actuel est globalement bien structuré mais pourrait bénéficier de plusieurs améliorations pour se conformer aux standards Ansible. Les corrections proposées permettront d'améliorer la maintenabilité, la lisibilité et la robustesse du code sans casser les fonctionnalités existantes.