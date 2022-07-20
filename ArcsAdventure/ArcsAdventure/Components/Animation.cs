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
        public Direction currentDirection { get; set; }
        private State currentState;
        private double counter;
        private int animationIndex;

        // constructor
        public Animation(int w, int h)
        {
            width = w;
            height = h;
            counter = 0;
            animationIndex = 0;
            currentState = State.Standing;
        }

        public override void Draw(SpriteBatch spriteBatch)
        {

        }

        public override void Update(double gameTime)
        {
            switch (currentState)
            {
                case State.Walking:
                    counter += gameTime;
                    if (counter > 200)
                    {
                        ChangeState();
                        counter = 0;
                    }
                    break;
            }
        }

        public void ResetCounter(State state, Direction direction)
        {
            if (currentDirection != direction)
            {
                counter = 1000;
                animationIndex = 0;
            }

            currentState = state;
            currentDirection = direction;
        }

        private void ChangeState()
        {
            switch (currentDirection)
            {
                case Direction.Left:
                    TextureRectangle = new Rectangle(animationIndex * width, height * (int)Direction.Left, width, height);
                    break;
                case Direction.Right:
                    TextureRectangle = new Rectangle(animationIndex * width, height * (int)Direction.Right, width, height);
                    break;
                case Direction.Up:
                    TextureRectangle = new Rectangle(animationIndex * width, height * (int)Direction.Up, width, height);
                    break;
                case Direction.Down:
                    TextureRectangle = new Rectangle(animationIndex * width, height * (int)Direction.Down, width, height);
                    break;
            }

            animationIndex = animationIndex == 0 ? 1 : 0;
            currentState = State.Standing;
        }
    }
}