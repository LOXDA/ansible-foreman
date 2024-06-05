# ansible-vault commands
( kudo to http://www.freekb.net/Articles?tag=Ansible )<br>

[**Ansible Vault password file**](#vaultfile) <br>
[**ansible-vault create**](#vaultcreate) <br>
ansible-vault decrypt <br>
ansible-vault edit <br>
ansible-vault encrypt <br>
ansible-vault encrypt_string <br>
ansible-vault rekey (change password) <br>
ansible-vault view <br>
ANSIBLE_VAULT_PASSWORD_FILE environment variable <br>
Copy an ansible vault encrypted file to managed nodes <br>
Decrypting a vault encrypted file <br>
[vault_password_file ansible.cfg](#vaultpasscfg) <br>

## <a name="#vaultfile"></a>Ansible - Ansible Vault password file

Create a file. <br> 
The file can be named anything you want. <br>
The file doesn't have to be hidden, but often is.<br>

    touch .vault_password.txt
 
Ensure only the owner of the file and create and write to the file.<br>

    chmod 0600 .vault_password.txt
 
If you have a single password that is being used with every ansible-vault command, append your vault password to the file.<br>

    echo "itsasecret" > .vault_password.txt
 
If you have different passwords being used, append each ``key: value`` pair to the file.<br>

    echo "test:testpassword" >> .vault_password.txt
    echo "prod:prodpassword" >> .vault_password.txt
 
You can then use the ``--vault-password-file`` command line option (if you are going to use the same password for all of the ansible-vault commands) . . .<br>

    ansible-vault --vault-password-file /usr/local/ansible/vault/.vault_password.txt view vault.yml

Or the ``--vault-id`` command line option (if you want to use different passwords).<br>

    ansible-vault create --vault-id test@/usr/local/ansible/vault/.vault_password.txt vault.yml

Or you could set the ``vault_password_file`` directive in your ``ansible.cfg`` file.<br>

    [defaults]
    vault_password_file = /usr/local/ansible/vault/.vault_password.txt
 
Or, you could use the ``ANSIBLE_VAULT_PASSWORD_FILE`` environment variable to set the path to the vault password file. <br> 
This is useful if you need to temporarily override ``vault_password_file`` in ``ansible.cfg``.<br>

    export ANSIBLE_VAULT_PASSWORD_FILE=/usr/local/vault/.vault_password.txt

In this scenario, you wouldn't need to use any of the vault password command line options (``--ask-vault-pass``, ``--vault-password-file``, ``--vault-id``).

    ansible-vault create vault.yml


## <a name="#vaultcreate"></a>Ansible - ansible-vault create command

Often, the ``ansible-vault create`` command is used to create an encrypted file in the ``group_vars/all`` directory,<br> 
so that variables in the encrypted file can be used by "all" hosts.<br> 
The file does not need to be named ``vault.yml``.<br> 
The file can be named anything you want.

    ansible-vault create group_vars/all/vault.yml
 
You will be prompted to create a new vault password.<br>

New Vault password:<br>
 
Or, to avoid being prompted for the vault password, you could create a **Vault Password file**, and then use the ``--vault-password-file``<br> 
command line option (if you are going to use the same password for all of the ansible-vault commands) . . .

    ansible-vault create --vault-password-file /usr/local/ansible/vault/.vault_password.txt group_vars/all/vault.yml


Or the ``--vault-id`` command line option (if you want to use different passwords) 

    ansible-vault create --vault-id test@~/git/project/.vault_password.txt group_vars/all/vault.yml

Or you could set the vault_password_file directive in your ansible.cfg file.<br>
In this scenario, you wouldn't need to use any of the vault password command line options (``--ask-vault-pass``, ``--vault-password-file``, ``--vault-id``).

    [defaults]
    vault_password_file = /usr/local/ansible/vault/.vault_password.txt
 
The file will open in your default editor. ``export EDITOR=nano``<br>
Let's say you enter ``vault_default_password: itsasecret`` and save ``vault.yml``.<br>
On a Linux system, ``vault.yml`` could have the following owner and permissions.<br>
In this example, only ``john.doe`` can read and write to vault.yml.<br>

    chmod 600 vault.yml
    ls -l vault.yml
    -rw-------. 1 john.doe john.doe  355 Mar 16 18:48 group_vars/all/vault.yml
 
Attempting to view the file using the cat command will display something like this.<br>
The ``ansible-vault view`` command can be used to view the content of the file.<br>

    $ANSIBLE_VAULT;1.1;AES256
    66303833643731313633343266616162613965636161313534376563383639646463376630626635
    3136316663626536303061333531303234616562323637330a373633393736393863373566623261
    65643764336263613730666665663763383063386137383331386136366232666637626566653032
    3933393061666138650a656238386665343838613833643435623932306539633138376533613039
    6531

If the file was encrypted with a vault id, the vault id (test in this example) will be included.<br>

    $ANSIBLE_VAULT;1.1;AES256;test
    66303833643731313633343266616162613965636161313534376563383639646463376630626635
    3136316663626536303061333531303234616562323637330a373633393736393863373566623261
    65643764336263613730666665663763383063386137383331386136366232666637626566653032
    3933393061666138650a656238386665343838613833643435623932306539633138376533613039
    6531

## <a name="#vaultpasscfg"></a>Ansible - vault_password_file ansible.cfg 

The ansible-vault command can be used to perform a number of tasks.

- ``ansible-vault create`` - create an encrypted file
- ``ansible-vault decrypt`` - decrypt and encrypted file
- ``ansible-vault edit`` - edit an encrypted file
- ``ansible-vault encrypt`` - encrypt a non-encrypted file
- ``ansible-vault encrypt_string`` - encrypt a string
- ``ansible-vault rekey`` - change password used to view or decrypt an encrypted file
- ``ansible-vault view`` - view the cleartext contents of an encryped file<br>

Additionally, there are a few command line options to be aware of.

- ``--ask-vault-pass`` - prompt for the vault password (or short: `-k` )
- ``--vault-id`` - use a specific users password in a file
- ``--vault-password-file`` - use a single password in a file

This assumes you have created the Ansible Vault password file.<br> 
Let's say the password file is:

    /usr/local/vault/.vault_password.txt

A vault password file can be used to provide the vault password when:

- Copying an encrypted file to managed nodes using the copy module
- Creating a new encrypted file using the ``ansible-vault create`` command
- Creating an encrypted key:value pair using the ``ansible-vault encrypt_string`` command
- Decrypting an encrypted file using the ``ansible-vault decrypt`` command
- Editing an encrypted file using the ``ansible-vault edit`` command
- Encrypting an unencrypted file using the ``ansible-vault encrypt`` command
- Viewing the content of an encrypted file using the ``ansible-vault view`` command

You could define ``vault_password_file`` in your ``ansible.cfg`` file.

in any of the files:<br>
``/etc/ansible/ansible.cfg`` (whole system)<br>
``~/ansible.cfg`` (user home)<br>
``./ansible.cfg`` (current dir)<br>

    [defaults]
    vault_password_file = /usr/local/ansible/vault/.vault_password.txt
 
Then you can view an encrypted file (``vault.yml``) without having to include the ``--vault-password-file`` or ``--vault-id`` command line options.

    ansible-vault view vault.yml
