class Utils 


@utils = new Utils()

Utils::getRandomColor = (start, end) ->
 color = 'rgb('+@getRandomInt(start,end)+', '+@getRandomInt(start,end)+', '+@getRandomInt(start,end)+')'
 @colorToHex(color)

Utils::getRandomInt = (min, max, exceptArray) ->
  randomInt = Math.floor(Math.random() * (max - min + 1)) + min

  if exceptArray?
    if exceptArray.indexOf(randomInt) > 0
      return getRandomInt(min, max, exceptArray)

  randomInt

Utils::colorToHex = (color) ->
  if color.substr(0, 1) is '#'
    return color
  
  digits = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(color)
  
  red = parseInt(digits[2])
  green = parseInt(digits[3])
  blue = parseInt(digits[4])
  
  rgb = blue | (green << 8) | (red << 16);
  digits[1] + '#' + rgb.toString(16);
