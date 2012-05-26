# FnordMetrics Event tracking


## To run this example locally

    bundle install
    RACK_ENV=development foreman start
    open http://localhost:5000
    
## To deploy to heroku
  
   heroku create --stack cedar
   git push heorku master
   heroku open
   
### Add some heroku goodies

   heroku addons:add redistogo:nano
   heroku addons:add newrelic  

   heroku config:add RACK_ENV=production

