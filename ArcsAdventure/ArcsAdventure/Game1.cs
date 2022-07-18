using ArcsAdventure.Components;
using ArcsAdventure.Manager;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace ArcsAdventure
{
    public class Game1 : Game
    {
        private GraphicsDeviceManager graphics;
        private SpriteBatch spriteBatch;
        private BaseObject player;
        private RenderTarget2D renderTarget;
        private ManagerInput mangerInput;
        private int vpHeight = 144;
        private int vpWidth = 160;

        public Game1()
        {
            graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;
            Window.AllowAltF4 = true;
            player = new BaseObject();
            mangerInput = new ManagerInput();
        }

        protected override void Initialize()
        {
            base.Initialize();
            int scale = 5;
            graphics.PreferredBackBufferHeight = vpHeight * scale;
            graphics.PreferredBackBufferWidth = vpWidth * scale;
            graphics.ApplyChanges();
        }

        protected override void LoadContent()
        {
            spriteBatch = new SpriteBatch(GraphicsDevice);
            renderTarget = new RenderTarget2D(GraphicsDevice, vpWidth, vpHeight);

            player.AddComponet(new Sprite(Content.Load<Texture2D>("Arc"), 16, 16, new Vector2(50, 50)));
            player.AddComponet(new PlayerInput());

            
        }

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                Exit();

            mangerInput.Update(gameTime.ElapsedGameTime.Milliseconds);
            player.Update(gameTime.ElapsedGameTime.Milliseconds);


            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            float vpScale = 1F / (144f / graphics.GraphicsDevice.Viewport.Height);
            Vector2 pos = new Vector2((graphics.GraphicsDevice.Viewport.Width - (vpWidth * vpScale)) / 2, 0);

            GraphicsDevice.SetRenderTarget(renderTarget);
            GraphicsDevice.Clear(new Color(197,207,161));

            spriteBatch.Begin();
            player.Draw(spriteBatch);
            spriteBatch.End();

            GraphicsDevice.SetRenderTarget(null);
            GraphicsDevice.Clear(Color.Black);

            spriteBatch.Begin(SpriteSortMode.Deferred, null, SamplerState.PointClamp, null, null, null, null);
            spriteBatch.Draw(renderTarget, pos, null, Color.White, 0f, Vector2.Zero, vpScale, SpriteEffects.None, 0f);
            spriteBatch.End();

            base.Draw(gameTime);
        }
    }
}
