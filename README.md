# kbot
This is a test DevOps application. Inside you can find Telegram bot with basic functionality, made with Go and Cobra-cli.\
To test it go to **https://t.me/antonsv_bot**

## Getting started
To try with your own account you need to add specific token from BotFather:
- ***TELE_TOKEN***: environment variable to connect your local repo with Telegram account
- ***export TELE_TOKEN=add_your_token***: export your token value into the local env

## Installation process
- First you need to clone github repo with ***git clone https://github.com/username/kbot.git***
- Go to newly created folder with ***cd kbot***
- Build the project locally with ***go build -o kbot*** (you will see kbot binary file in the folder tree)

## How to use
- To start your bot type ***./kbot start***
- By providing commands inside Telegram bot page you will receive answers and logs in local console.
