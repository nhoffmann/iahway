_gaq = _gaq || []
_gaq.push(['_setAccount', 'UA-21359556-5'])
_gaq.push(['_trackPageview'])

( () ->
  ga = document.createElement('script')
  ga.type = 'text/javascript'
  ga.async = true
  ga.src = ('https:' is document.location.protocol and 'https://ssl' or 'http://www') + '.google-analytics.com/ga.js'
  s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s)
)()
