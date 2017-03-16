#devtools::install_github("rstudio/reticulate")

library(reticulate)
library(dplyr)


### we need to switch to python 27 because the pattern packages supports only python27 and not python3
### In anaconda I have created a python 2.7 environment woth the pateern.nl package
### In R We can use this environment 

use_condaenv("python27")

psys = import('sys')
psys$version

### import the pattern library pattern.nl is the specific Dutch version
pattern.nl = import("pattern.nl")

### singularize some dutch words
pattern.nl$singularize("katten")
pattern.nl$singularize("huizen")


### call the sentiment function
out = pattern.nl$sentiment('ALS is een zeer vreselijk ziekte')

## out is still a 'python object'
## its assement object contain a polarity score between -1 and 1 and a subjectivity score (0,1)
out$assessments[[1]][[1]]
out$assessments[[1]][[2]]
out$assessments[[1]][[3]]

out = pattern.nl$sentiment('Het is vandaag een prachtige mooie dag')
out$assessments[[1]][[2]]


##########  perform sentiment on multiple texts

sentPolarity = function(text)
{
  out = pattern.nl$sentiment(text)
  if(length(out$assessments) < 1)
  {
    return(NA)
  }
  else{
    return(out$assessments[[1]][[2]])
  }
}


texts = c(
  "Alle passagiers van het gekaapte vliegtuig op Malta zijn vrijgelaten. De gijzelnemers hebben zich overgegeven en zijn opgepakt. Het Libische toestel werd vanochtend gekaapt. Aan boord waren 111 passagiers en 7 bemanningsleden. Na een paar uur lieten de kapers de eerste groep passagiers vrij: 25 vrouwen en kinderen. Daarna volgden nog twee groepen.   Rond 15:45 uur maakte premier Joseph Muscat van Malta bekend dat de kaping voorbij was.   Hijackers surrendered, searched and taken in custody. Het zou gaan om twee kapers. Ze dreigden het toestel op te blazen. Lokale media melden dat het zou gaan om aanhangers van de in 2011 overleden Libische dictator Khadaffi. Wat de eisen precies waren, is niet duidelijk.  Het toestel was op weg van Sebha, in het zuidwesten van Libië, naar Tripoli. Malta ligt zo'n 300 kilometer ten noorden van Libië.  ",
  "De Russische ambassadeur in Turkije, Andrei Karlov, is overleden. Dat meldt het Russische persbureau RIA. Karlov werd neergeschoten tijdens een toespraak in een fotomuseum in Ankara. Karlov was aanwezig bij een tentoonstelling in Ankara. Hij werd in zijn rug geschoten door een nog onbekende schutter. De dader zou de tentoonstelling zijn binnengekomen door zich voor te doen als agent. De schutter zou hebben geroepen \"wij sterven in Aleppo, jij sterft hier\", nadat hij Karlov had doodgeschoten. Rusland is militair betrokken bij het conflict in Syrië. De Russen steunen president Assad. Karlov was 62 jaar oud. Hij was sinds 2013 de Russische ambassadeur in Ankara. Na de schietpartij werd Karlov overgebracht naar het ziekenhuis, waar hij is overleden aan zijn verwondingen. De dader is door de politie doodgeschoten.  Bekijk hier de beelden van het moment dat Karlov werd doodgeschoten (let op: schokkende beelden)",
  "De Russische ambassadeur in Turkije is neergeschoten. Andrei Karlov zou zwaargewond zijn geraakt en is overgebracht naar het ziekenhuis. De Turkse krant Hürriyet heeft een foto van Karlov die bloedend op de grond ligt. Hij zou zijn neergeschoten bij een fototentoonstelling. Het Russische ministerie van Buitenlandse Zaken heeft de schietpartij bevestigd. De Turkse zender CNN Turk zegt dat de ambassadeur 'in kritieke toestand' in het ziekenhuis ligt. Volgens persbureau AP hield Karlov een toespraak bij de fototentoonstelling in de Turkse hoofdstad Ankara, toen er geschoten werd. De schutter zou nog steeds rondlopen in het gebouw. Er zou ook nog steeds geschoten worden. De dader van de schietpartij zou een radicale islamist zijn, al is dat nog onbevestigd. Hij zou inmiddels door de politie zijn doodgeschoten, meldden verschillende Turkse media. De Russische ambassadeur in Ankara is Andrej Karlov. Aanslag bij een expositie, volgens @Hurriyet is dit de foto https://t.co/7SOkTnpAj8 pic.twitter.com/7CHqPp6rY2  "  ,
  "Op de A9 is tijdens wegwerkzaamheden een constructie met matrixborden op een auto gevallen. Daarbij zijn in ieder geval een dode en een gewonde gevallen. De snelweg is in beide richtingen dicht. De snelweg was door werkzaamheden al dicht in de richting Amstelveen. Richting Diemen is de weg nu ook afgesloten. Een portaal is de constructie boven de (snel)weg waaraan bijvoorbeeld bewegwijzeringsborden en matrixborden hangen. De ANWB twittert dat 'het helemaal mis gegaan is bij werkzaamheden'. Het gevaarte zou mogelijk uit een kraan zijn gevallen. Daarbij werden twee auto's geraakt. Een bestuurder overleed, de ander moest door de brandweer worden bevrijd.  @at5 @nhnieuws ongeluk op snelweg bij werkzaamheden? Ter hoogte afslag weesp pic.twitter.com/z9xmKr4em3 Rijkswaterstaat verwacht dat de weg tot aan 22.00 uur vanavond dicht blijft. Het verkeer wordt omgeleid via de A2, A12 en A27." ,
  "In het Franse dorpje Sisco op Corsica mogen moslims geen boerkini's meer dragen. Dat heeft burgemeester Ange-Pierre Vivoni van het dorp bepaald. Aanleiding was een vechtpartij gisteren op het strand van het dorp tussen lokale jeugd en families van Noord-Afrikaanse afkomst. Volgens ooggetuigen begon de vechtpartij toen een jongeling op het strand foto's maakte van enkele vrouwen die zwommen in boerkini. De moslims reageerden daarop agressief en al snel waren er rond de 40 dorpsbewoners die de lokale jeugd bijstonden. De auto's van de moslims moesten het daarbij ontgelden. Er zouden bijlen en harpoenen gebruikt zijn bij het incident, waarbij vijf gewonden vielen. Zij mochten snel weer het ziekenhuis uit.  Sisco is de derde Franse plaats deze maand waar de boerkini verboden is. Ook in Cannes en Villeneuve-Loubet is het badpak voor moslima's inmiddels niet meer toegestaan. Meer op rtlnieuws.nl:Moslima Nora vindt verbod op boerkini oneerlijk: 'Wij worden afgerekend op de aanslagen'"
)

outpol = lapply(texts, sentPolarity) %>% unlist()
outpol
