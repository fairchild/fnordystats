# Track Events From Foundry Apps


## To run this example locally

    bundle install
    RACK_ENV=development foreman start
    open http://localhost:5000
    
## To deploy to heroku
  
   heroku create --stack cedar
   git push heorku master
   heroku open
   
### Add some heroku goodies

   heroku addons:add releases
   heroku addons:upgrade releases:advanced
   heroku addons:upgrade logging:expanded
   heroku addons:add redistogo:nano
   heroku addons:add newrelic  

   heroku config:add RACK_ENV=staging

# Deploying
cap deploy : deploys to staing
cap production deploy: deploys to production

