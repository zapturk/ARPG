using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Text;

namespace ArcsAdventure
{
    class BaseObject
    {
        public int Id { get; set; }
        private readonly List<Component> components;

        // constructor
        public BaseObject()
        {
            components = new List<Component>();
        }

        // finds a componet given its type
        public TComponentType GetComponent<TComponentType>(ComponentType componentType) where TComponentType : Component
        {
            return components.Find(c => c.ComponentType == componentType) as TComponentType;
        }

        // add a single componet from the list
        public void AddComponet(Component component)
        {
            components.Add(component);
            component.Initialize(this);
        }

        // add a list of componet from the list
        public void AddComponet(List<Component> components)
        {
            components.AddRange(components);
            foreach(var component in components)
            {
                component.Initialize(this);
            }
        }

        // remove a componet from the list
        public void RemoveComponet(Component component)
        {
            components.Remove(component);
        }

        // calls the update for each componet
        public void Update(double gameTime)
        {
            foreach(var component in components)
            {
                component.Update(gameTime);
            }
        }

        // calls the draw for each componet
        public void Draw(SpriteBatch spriteBatch)
        {
            foreach (var component in components)
            {
                component.Draw(spriteBatch);
            }
        }
    }
}
