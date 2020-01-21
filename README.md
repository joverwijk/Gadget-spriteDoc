This gadget uses JavaScript to load in sprite data in the way its Lua
counterpart does. The only difference is that, instead of using up the
transclusion limit, it does it after the page has loaded and thus effectively
circumventing this limit.

# Overview
This gadget has two main files where it works from. These are:

* the JavaScript (js/Gadget-spriteDoc.js);
* the accompanying CSS (css/Gadget-spriteDoc.css).

For the gadget to work correctly, though, a couple of supplementary files have
been included. These are:

* the Lua sprite module (lua/Sprite.lua);
* the LoadSprite template (templates/LoadSprite.txt);
* the LoadSprite widget (widgets/LoadSprite.txt).

# Components
Below follows an explanation of the files necessary to make this gadget work as
intended.

## js/Gadget-spriteDoc.js
This file is responsible for all the logic while the sprite documentation is
loaded. It supports partial internationalization using the `i18n` variable.
More internationalization options will be made available at a later date - feel
free to ping me for that.

## css/Gadget-spriteDoc.css
This file is responsible for the styling of the sprite documentation. It is
essentially a clone of [Widget:SpriteDoc.css](https://minecraft.gamepedia.com/Widget:SpriteDoc.css),
minus the `style` elements and categorization.

## lua/Sprite.lua
This Lua module includes all the necessary changes in order to make the sprite
documentation work as expected. It is recommended to at least copy and paste
(or type over) the functions `p.doc` and `p.getRawSpriteData` and adapt them as
necessary for you situation.

## templates/LoadSprite.txt
This template is not necessary in the sense that you _must_ have it in order to
make the sprite documentation work as intended. However, it does provide a nice
shell around the `{{#invoke:}}` call. A regular `{{#invoke:}}` call on the
documentation page will work just fine for it.

## widgets/LoadSprite.txt
The widget is, however, a necessity. This is because the script will actively
look for it and use it to load the sprite data. It is a custom element, named
`loadsprite` (or any name you give it, just keep in mind the
internationalization). The only attribute given is `sprite`, which is the name
of the sprite that needs to be loaded.

Upon load completion of the documentation, this element will be removed from
the DOM.

# Compatibility
The sprite documentation gadget has been found to work correctly on Mozilla
Firefox, Google Chrome (latest version, also for the latest available for
Windows XP) and Microsoft Edge.

Internet Explorer has not been taken into account during the creation of this
gadget and **never** will be, given that the usage worldwide of the latest
version of it (11) is only [1.57%](https://gs.statcounter.com/) as of typing.

# Instructions
