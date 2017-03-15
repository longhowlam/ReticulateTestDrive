###############################################################################
##
##   Image recognition using clarifai
##   make sure to install the python module from clarifai,
##   see https://github.com/Clarifai/clarifai-python for instructions

library(reticulate)
library(listviewer)

#### import the clarifai module

cf = import("clarifai")
clf_app = cf$rest$ClarifaiApp()

############ call the general computer vision model of clarifai ###############

outclarify = clf_app$tag_urls(
  list('https://samples.clarifai.com/metro-north.jpg')
  )

### the output of the clarifai app is a nested list, which can be quite 
### intimidating the listviewer package is handy to view these nested lists

listviewer::jsonedit(outclarify)

############# Not safe for work model #########################################

outclarify = clf_app$tag_urls(
  list('https://www.persellshop.nl/images/detailed/2/73416_C.jpg'), 
  model='nsfw-v1.0'
)

########### the celebrity model (alpha) ######################################

### define the model
celeb_model = clf_app$models$get('e466caa0619f444ab97497640cefc4dc')

### create image objects 
img1 = cf$rest$Image(url = "https://samples.clarifai.com/celebrity.jpeg")
img2 = cf$rest$Image(url = "http://ll-media.tmz.com/2006/09/29/pitt2-1.jpg")

celeb_out = celeb_model$predict(list(img1, img2))
jsonedit(celeb_out)




