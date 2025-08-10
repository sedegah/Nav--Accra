module Main where

import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import Data.Maybe (fromMaybe)
import Data.List (minimumBy, intercalate)
import Data.Ord (comparing)

type Node = String
type Weight = Double
type Graph = Map.Map Node [(Node, Weight)]

graph :: Graph
graph = Map.fromList
  [ ("Kotoka Airport", [("Osu",7.0), ("Achimota",15.0), ("Madina",20.0)])
  , ("Osu", [("Kotoka Airport",7.0), ("Accra Central",4.0), ("Labadi",3.5), ("Adabraka",6.0)])
  , ("Achimota", [("Kotoka Airport",15.0), ("Accra Central",10.0), ("Mallam",5.0), ("Achimota Mall",3.0)])
  , ("Accra Central", [("Osu",4.0), ("Achimota",10.0), ("Labadi",5.0), ("Circle",6.0), ("Adabraka",5.0), ("East Legon",12.0)])
  , ("Labadi", [("Osu",3.5), ("Accra Central",5.0), ("Teshie",7.0)])
  , ("Madina", [("Kotoka Airport",20.0), ("Tema",25.0), ("Adenta",8.0), ("East Legon",10.0), ("University of Ghana",4.0), ("Kwabenya",10.0)])
  , ("Mallam", [("Achimota",5.0), ("Tudu",12.0), ("Kaneshie",8.0)])
  , ("Circle", [("Accra Central",6.0), ("Tudu",3.0), ("Tema",28.0), ("Adabraka",4.0)])
  , ("Tudu", [("Mallam",12.0), ("Circle",3.0), ("Nungua",18.0), ("Kaneshie",5.0)])
  , ("Tema", [("Madina",25.0), ("Circle",28.0), ("Nungua",15.0), ("Spintex",15.0)])
  , ("Nungua", [("Tema",15.0), ("Tudu",18.0), ("Teshie",5.0)])
  , ("Teshie", [("Labadi",7.0), ("Nungua",5.0), ("Ada",40.0)])
  , ("Adenta", [("Madina",8.0), ("Pantang",6.0)])
  , ("Pantang", [("Adenta",6.0), ("Abokobi",7.0)])
  , ("Abokobi", [("Pantang",7.0), ("Ofankor",10.0)])
  , ("Ofankor", [("Abokobi",10.0), ("Spintex",12.0)])
  , ("Spintex", [("Ofankor",12.0), ("Tema",15.0), ("East Legon",14.0)])
  , ("East Legon", [("Madina",10.0), ("Spintex",14.0), ("University of Ghana",5.0), ("Kwabenya",8.0), ("Accra Central",12.0)])
  , ("University of Ghana", [("East Legon",5.0), ("Madina",4.0)])
  , ("Kwabenya", [("East Legon",8.0), ("Madina",10.0)])
  , ("Adabraka", [("Accra Central",5.0), ("Osu",6.0), ("Circle",4.0)])
  , ("Circle", [("Adabraka",4.0), ("Accra Central",6.0), ("Tudu",3.0)])
  , ("Kaneshie", [("Mallam",8.0), ("Tudu",5.0)])
  , ("Achimota Mall", [("Achimota",3.0), ("Mallam",7.0)])
  , ("Ada", [("Teshie",40.0)])
  ]

-- Dijkstra's algorithm with path reconstruction
dijkstra :: Graph -> Node -> (Map.Map Node Weight, Map.Map Node (Maybe Node))
dijkstra graph start = go initialDist initialPrev initialQueue
  where
    nodes = Map.keysSet graph
    initialDist = Map.insert start 0 $ Map.fromSet (const (1/0)) nodes
    initialPrev = Map.fromSet (const Nothing) nodes
    initialQueue = nodes

    go :: Map.Map Node Weight -> Map.Map Node (Maybe Node) -> Set.Set Node -> (Map.Map Node Weight, Map.Map Node (Maybe Node))
    go dist prev queue
      | Set.null queue = (dist, prev)
      | otherwise =
          let u = minimumBy (comparing (\n -> Map.findWithDefault (1/0) n dist)) (Set.toList queue)
              queue' = Set.delete u queue
              neighbors = fromMaybe [] (Map.lookup u graph)
              (dist', prev') = relaxNeighbors u neighbors dist prev
          in go dist' prev' queue'

    relaxNeighbors :: Node -> [(Node, Weight)] -> Map.Map Node Weight -> Map.Map Node (Maybe Node) -> (Map.Map Node Weight, Map.Map Node (Maybe Node))
    relaxNeighbors _ [] dist prev = (dist, prev)
    relaxNeighbors u ((v,w):ns) dist prev =
      let alt = Map.findWithDefault (1/0) u dist + w
          oldDist = Map.findWithDefault (1/0) v dist
      in if alt < oldDist
         then relaxNeighbors u ns (Map.insert v alt dist) (Map.insert v (Just u) prev)
         else relaxNeighbors u ns dist prev

-- Reconstruct path from prev map
reconstructPath :: Map.Map Node (Maybe Node) -> Node -> [Node]
reconstructPath prevMap target =
  case Map.lookup target prevMap of
    Nothing -> [] -- no path
    Just Nothing -> [target]
    Just (Just p) -> reconstructPath prevMap p ++ [target]

-- Check if node exists in graph
nodeExists :: Node -> Graph -> Bool
nodeExists node g = Map.member node g

-- Main interaction loop
main :: IO ()
main = do
  putStrLn "Welcome to the Accra Road Navigator (Dijkstra's algorithm in Haskell)!"
  putStrLn "Available locations:"
  mapM_ putStrLn (Map.keys graph)
  loop
  where
    loop :: IO ()
    loop = do
      putStrLn "\nEnter start location:"
      start <- getLine
      if not (nodeExists start graph)
        then putStrLn "Start location not found. Please try again." >> loop
        else do
          putStrLn "Enter destination location:"
          dest <- getLine
          if not (nodeExists dest graph)
            then putStrLn "Destination location not found. Please try again." >> loop
            else do
              let (distMap, prevMap) = dijkstra graph start
              let dist = Map.lookup dest distMap
              case dist of
                Nothing -> putStrLn "No path found."
                Just d -> do
                  let path = reconstructPath prevMap dest
                  putStrLn $ "\nShortest distance from " ++ start ++ " to " ++ dest ++ ": " ++ show d ++ " km"
                  putStrLn $ "Route: " ++ intercalate " -> " path
              askContinue

    askContinue :: IO ()
    askContinue = do
      putStrLn "\nDo you want to find another route? (yes/no)"
      ans <- getLine
      if ans `elem` ["yes","y","Y"]
        then loop
        else putStrLn "Thank you for using the Accra Road Navigator. Goodbye!"
