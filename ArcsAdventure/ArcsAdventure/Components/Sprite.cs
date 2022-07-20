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
            var animation = GetComponent<Animation>(ComponentType.Animation);
            if (animation != null)
            {
                spriteBatch.Draw(texture, new Rectangle((int)position.X, (int)position.Y, width, height), animation.TextureRectangle, Color.White);
            }
            else
            {
                spriteBatch.Draw(texture, new Rectangle((int)position.X, (int)position.Y, width, height), Color.White);
            }            
        }

        public override void Update(double gameTime)
        {
           
        }

        internal void Move(float x, float y)
        {
            position = new Vector2(position.X + x, position.Y + y);
            var animation = GetComponent<Animation>(ComponentType.Animation);
            if (animation != null)
            {
                if(x > 0){
                    animation.ResetCounter(State.Walking, Direction.Right);
                }
                else if(x < 0){
                    animation.ResetCounter(State.Walking, Direction.Left);
                }
                else if(y > 0){
                    animation.ResetCounter(State.Walking, Direction.Down);
                }
                else if(y < 0){
                    animation.ResetCounter(State.Walking, Direction.Up);
                }
            }

        }
    }
}
