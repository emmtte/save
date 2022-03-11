TELEGRAM_TOKEN=
TELEGRAM_CHATID=
NAME=$(hostname | tr '[a-z]' '[A-Z]')

Menu() {
  ADVSEL=$(whiptail --title "Menu" --menu "Choose an option" 15 60 4 \
      "1" "Backup" \
      "2" "Restore" 3>&1 1>&2 2>&3)

  case $ADVSEL in
        1)
        tput reset ; Backup
        whiptail --title "Backup" --msgbox "For restore, please forward gpg file in bot" 8 45
        Menu
        ;;

        2)
        whiptail --title "Restore" --msgbox "Please check latest gpg file as forwarded" 8 45
        tput reset ; Restore
        Menu
        ;;
        esac
    }

Backup() {
cd ~
tar --create --gzip --verbose --file=/tmp/backup.tgz --files-from ~/backup.txt
export GPG_TTY=$(tty)
gpg -o /tmp/backup.tgz.gpg --encrypt /tmp/backup.tgz
curl --silent https://api.telegram.org/bot$TELEGRAM_TOKEN/sendDocument -F document=@"/tmp/backup.tgz.gpg" -F chat_id=$TELEGRAM_CHATID -F caption=$NAME > /dev/null
rm /tmp/backup.tgz /tmp/backup.tgz.gpg
}


Restore() {
cd ~
FILE_ID=$(curl --silent  https://api.telegram.org/bot$TELEGRAM_TOKEN/getUpdates | jq --raw-output .result[-1].message.document.file_id)
FILE_PATH=$(curl --silent https://api.telegram.org/bot$TELEGRAM_TOKEN/getFile -F file_id=$FILE_ID | jq --raw-output .result.file_path)
if [ "$FILE_PATH" = "null" ] ; then echo "ERROR TELEGRAM FILE_PATH" ; exit 1 ; fi
curl --silent https://api.telegram.org/file/bot$TELEGRAM_TOKEN/$FILE_PATH --output /tmp/backup.tgz.gpg
gpg --output /tmp/backup.tgz --decrypt /tmp/backup.tgz.gpg
mkdir /tmp/restore
tar -zxf /tmp/backup.tgz --directory /tmp/restore
rm /tmp/backup.tgz /tmp/backup.tgz.gpg
}

Menu
