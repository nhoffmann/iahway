class Utils 


@utils = new Utils()

Utils::getRandomInt = (min, max, exceptArray) ->
  randomInt = Math.floor(Math.random() * (max - min + 1)) + min

  if exceptArray?
    if exceptArray.indexOf(randomInt) > 0
      return getRandomInt(min, max, exceptArray)

  randomInt