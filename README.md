## Backup / Restore
### Prerequisites
```
sudo apt install -y curl gpg jq
gpg --import private.key
```

### Telegram Bot
- https://telegram.me/botfather
1. Use the **/newbot** command to create a new bot. The BotFather will ask you for a name and username, then generate an authorization token for your new bot.
2. The **name** of your bot is displayed in contact details and elsewhere.
3. The **Username** is a short name, to be used in mentions and telegram.me links. Usernames are 5-32 characters long and are case insensitive, but may only include Latin characters, numbers, and underscores. Your bot's username must end in ‘bot’.
4. Copy the **TOKEN** to the file backup.sh as TELEGRAM_TOKEN
5. Send a dummy message to your new bot
6. Go to following url https://api.telegram.org/botTOKEN/getUpdates
7. Look for ``"chat":{"id":``
8. Copy the **chatid** to the file backup.sh as TELEGRAM_CHATID 
````
TELEGRAM_TOKEN=""
curl https://api.telegram.org/bot$TELEGRAM_TOKEN/getUpdates | jq .result[0].message.chat.id
````
