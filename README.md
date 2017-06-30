# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


# API

## Get Products
http://localhost:4000/api/v1/products.json?token=1375e7e9ef762240bdc94e59c51b56f8f17d67804eeed43f

## Get Product
http://localhost:4000/api/v1/products/4/?token=1375e7e9ef762240bdc94e59c51b56f8f17d67804eeed43f

## Update Product
curl -i -X PUT -H "X-Spree-Token: 1375e7e9ef762240bdc94e59c51b56f8f17d67804eeed43f" -d "product[name]=Headphones" \
http://localhost:4000/api/v1/products/1 \
    
## Create 
curl -i -X POST -H "X-Spree-Token: 1375e7e9ef762240bdc94e59c51b56f8f17d67804eeed43f" -d "product[name]=Prod1&product[price]=1000&product[shipping_category_id]=1" \
http://localhost:4000/api/v1/products

1375e7e9ef762240bdc94e59c51b56f8f17d67804eeed43f
    
## Ref
http://elh.mx/rails/spree-resources-and-routes-for-api-using-curl-or-ajax-calls/
https://gist.github.com/jcowhigjr/4021246

    
