using ArcsAdventure.MyEventArgs;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.Text;

namespace ArcsAdventure.Manager
{
    class ManagerInput
    {
        private KeyboardState keyState;
        private KeyboardState lastKeyState;
        private Keys lastKey;
        private static event EventHandler<NewInputEventArgs> fireNewInput;
        private double counter;
        private static double cooldown;

        public static event EventHandler<NewInputEventArgs> FireNewInput
        {
            add { fireNewInput += value;  }
            remove { fireNewInput -= value; }
        }
        public static bool ThrottleInput { get; set; }
        public static bool LockMovement { get; set; }

        // constructor
        public ManagerInput()
        {
            ThrottleInput = false;
            LockMovement = false;
            counter = 0;
        }

        public void Update(double gameTime)
        {
            if(cooldown > 0)
            {
                counter += gameTime;
                if (counter > gameTime)
                {
                    cooldown = 0;
                    counter = 0;
                }
                else
                    return;
            }

            ComputerControlls(gameTime);
        }

        public void ComputerControlls(double gameTime)
        {
            keyState = Keyboard.GetState();
            if(keyState.IsKeyUp(lastKey) && lastKey != Keys.None)
            {
                if(fireNewInput != null)
                {
                    fireNewInput(this, new NewInputEventArgs(Input.None));
                }
            }

            CheckKeyState(Keys.Left, Input.Left);
            CheckKeyState(Keys.Right, Input.Right);
            CheckKeyState(Keys.Up, Input.Up);
            CheckKeyState(Keys.Down, Input.Down);

            lastKeyState = keyState;
        }

        private void CheckKeyState(Keys key, Input fireInput)
        {
            if (keyState.IsKeyDown(key))
            {
                if(!ThrottleInput || (ThrottleInput && lastKeyState.IsKeyUp(key)))
                {
                    if(fireNewInput != null)
                    {
                        fireNewInput(this, new NewInputEventArgs(fireInput));
                        lastKey = key;
                    }
                }
            }
        }
    }
}
