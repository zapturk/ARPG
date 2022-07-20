using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;


namespace ArcsAdventure.Map
{
    class Tile
    {
        private const int width = 16;
        private const int height = 16;

        public int XPos { get; set; }
        public int YPos { get; set; }
        public int ZPos { get; set; }

        public int TextureXPos { get; set; }
        public int TextureYPos { get; set; }

        public string TextureName { get; set; }
        private Texture2D texture;


        public Tile()
        {

        }

        public Tile(int xPos, int yPos, int zPos, int textureXPos, int textureYPos, string textureName)
        {
            XPos = xPos;
            YPos = yPos;
            ZPos = zPos;
            TextureXPos = textureXPos;
            TextureYPos = textureYPos;
            TextureName = textureName;
        }

        public void LoadContent(ContentManager content)
        {
            texture = content.Load<Texture2D>(TextureName);
        }

        public void Update(double gameTime)
        {

        }

        public void Draw(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(texture, new Rectangle(XPos * width, YPos * height, width, height), new Rectangle(XPos * width, YPos * height, width, height), Color.White);
        }
    }
}
