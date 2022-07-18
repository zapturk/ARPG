using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Text;

namespace ArcsAdventure
{
    abstract class Component
    {
        private BaseObject baseObject;
        public abstract ComponentType ComponentType { get; }


        // Set the base object
        public void Initialize(BaseObject baseObj)
        {
            baseObject = baseObj;
        }

        // returns the id of the base obj
        public int GetOwnerId()
        {
            return baseObject.Id;
        }

        // remove itself from the list
        public void RevomeMe()
        {
            baseObject.RemoveComponet(this);
        }

        // finds a componet given its type
        public TComponentType GetComponent<TComponentType>(ComponentType componentType) where TComponentType : Component
        {
            return baseObject.GetComponent<TComponentType>(componentType);
        }


        // update method
        public abstract void Update(double gameTime);

        // Draw method
        public abstract void Draw(SpriteBatch spriteBatch);
    }
}
