using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Text;

namespace ArcsAdventure.Components
{
    class Sprite : Component
    {
        private Texture2D texture;
        private int width;
        private int height;
        private Vector2 position;

        // constructor
        public Sprite(Texture2D spr, int w, int h, Vector2 pos)
        {
            texture = spr;
            width = w;
            height = h;
            position = pos;
        }

        public override ComponentType ComponentType
        {
            get { return ComponentType.Sprite; }
        }

        public override void Draw(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(texture, new Rectangle((int)position.X, (int)position.Y, width, height), Color.White);
        }

        public override void Update(double gameTime)
        {
            
        }
    }
}
