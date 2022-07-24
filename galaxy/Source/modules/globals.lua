import 'modules/markov'

pd = playdate
gfx = pd.graphics
geo = pd.geometry

galaxy = nil
markovChainGenerator = MarkovChain('stellar')

start = { x = 5, y = 30 }
starStart = { x = start.x + 5, y = start.y + 5 }

galaxyTotalWidth = pd.display.getWidth() * 8/9
galaxyTotalHeight = pd.display.getHeight() * 6/7

galaxyDims = geo.vector2D.new(galaxyTotalWidth, galaxyTotalHeight)

nSectorsX = galaxyDims.x / 16
nSectorsY = galaxyDims.y / 16

tempSeed = pd.getSecondsSinceEpoch()
math.randomseed(tempSeed)
globalSeed = math.random()
