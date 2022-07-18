using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace ArcsAdventure.Components
{
    class Animation : Component
    {
        public override ComponentType ComponentType
        {
            get { return ComponentType.Animation; }
        }

        private int width;
        private int height;
        public Rectangle TextureRectangle { get; private set; }
        public Direction Direction { get; set; }
        private State curentState;
        private double counter;
        private int animationIndex;

        // constructor
        public Animation(int w, int h)
        {
            width = w;
            height = h;
            counter = 0;
            animationIndex = 0;
            curentState = State.Standing;
        }

        public override void Draw(SpriteBatch spriteBatch)
        {

        }

        public override void Update(double gameTime)
        {
            switch (curentState)
            {
                case State.Standing:
                    counter += gameTime;
                    if (counter > 500)
                    {
                        ChangeState();
                        counter = 0;
                    }
                    break;
            }
        }

        private void ChangeState()
        {
            switch (Direction)
            {
                case Direction.Left:

                    break;
                case Direction.Right:

                    break;
                case Direction.Up:

                    break;
                case Direction.Down:

                    break;
            }
        }
    }
}