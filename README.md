# email-mixer

A Ruby command-line applicaton to generate email-address variations given first, last, and domain names.

## Installation
1. Download script file
2. Open Terminal; change to `Downloads` diretory:

    ```bash
    $ cd ~/Downloads
    ```
3. Make Ruby script executable:

    ```bash
    $ chmod +x mix.rb
    ```
4. Rename if desired:

    ```bash
    $ mv mix.rb mix
    ```
5. Move to directory on path, if desired:

    ```bash
    $ mv mix /usr/local/bin
    ```

## Usage
Assuming file has been renamed `mix` and moved to `/usr/local/bin`.

### Create variants of john q public:
```bash
$ mix domain.com john public q
john.public@domain.com,johnpublic@domain.com,jpublic@domain.com,johnp@domain.com,publicjohn@domain.com,publicj@domain.com,john.q.public@domain.com,johnqpublic@domain.com,john.q.public@domain.com,johnqpublic@domain.com,jqpublic@domain.com,johnqp@domain.com,publicjq@domain.com
```
### Create variants of john public with a semicolon:
```bash
$ mix -d semicolon domain.com john public
john.public@domain.com;johnpublic@domain.com;jpublic@domain.com;johnp@domain.com;publicjohn@domain.com;publicj@domain.com
```

### Use with Mail
1. Create variants with a comma (output results to clipboard):

    ```bash
    mix -o clipboard domain.com john public
    ```

2. Open Mail; create new Message; select BCC line; paste results

### Use with Microsoft Outlook for Mac 2011
1. Create variants with a semicolon (output results to clipboard):

    ```bash
    mix -d semicolon -o clipboard domain.com john public
    ```

2. Open Outlook; create new Outlook Message; select BCC line; paste results
