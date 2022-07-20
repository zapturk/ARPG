using System;
using System.Collections.Generic;
using ArcsAdventure.Map;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;

namespace ArcsAdventure.Manager
{
    class ManagerMap
    {
        private List<Tile> Tiles;
        private string MapName;

        public ManagerMap(string mapName)
        {
            MapName = mapName;
        }

        public void LoadContent(ContentManager content)
        {
            var tiles = new List<Tile>();
            XMLSerialization.LoadXML(out tiles, string.Format("Content\\Maps\\{0}\\{0}_tiles.map", MapName));
            if (tiles != null)
            {
                Tiles = tiles;
                Tiles.Sort((n, i) => n.ZPos > i.ZPos ? 1 : 0);
                foreach (var tile in Tiles)
                {
                    tile.LoadContent(content);
                }
            }
        }

        public void Update(double gameTime)
        {
            foreach (var tile in Tiles)
            {
                tile.Update(gameTime);
            }
        }

        public void Draw(SpriteBatch spriteBatch)
        {
            foreach (var tile in Tiles)
            {
                tile.Draw(spriteBatch);
            }
        }
    }
}
