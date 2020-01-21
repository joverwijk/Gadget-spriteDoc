This gadget uses JavaScript to load in sprite data in the way its Lua
counterpart does. The only difference is that, instead of using up the
transclusion limit like Lua would, the gadget loads all sprite data after the
page has loaded, effectively circumventing the transclusion limit.

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

## `js/Gadget-spriteDoc.js`
This file is responsible for all the logic while the sprite documentation is
loaded. It supports partial internationalization using the `i18n` variable.
More internationalization options will be made available at a later date - feel
free to ping me for a chance of more internationalization sooner than I
originally intended.

## `css/Gadget-spriteDoc.css`
This file is responsible for the styling of the sprite documentation. It is
essentially a clone of [Widget:SpriteDoc.css](https://minecraft.gamepedia.com/Widget:SpriteDoc.css),
minus the `style` elements and categorization.

## `lua/Sprite.lua`
This Lua module includes all the necessary changes in order to make the sprite
documentation work as expected. It is recommended to at least copy and paste
(or type over) the functions `p.doc` and `p.getRawSpriteData` and adapt them as
necessary for you situation.

## `templates/LoadSprite.txt`
This template is not necessary in the sense that you _must_ have it in order to
make the sprite documentation work as intended. However, it does provide a nice
shell around the `{{#invoke:}}` call. A regular `{{#invoke:}}` call on the
documentation page will work just fine for it.

## `widgets/LoadSprite.txt`
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
version of it (11) is only [1.57%](https://gs.statcounter.com/) as of typing
and adding a possible compatibility layer to the sprite documentation loader
gives too much of an overhead for what it's worth.

# Compromises
Disabling the sprite editor is no longer possible after importing this gadget.
This is because the sprite editor loader has been integrated into this gadget,
as it proved to be outright difficult to make sure all sprite data had been
loaded correctly before the sprite editor was loaded.

As one does not necessarily _have_ to use the sprite editor, this compromise
was made between a non-loading sprite documentation because the transclusion
size is too big and a gadget implementation actually rendering the sprite
documentation.

# Instructions
## Prerequisites
This instructions manual assumes your wiki is already using sprites as seen on
the [Minecraft Wiki](https://minecraft.gamepedia.com/Template:Sprite).

## Importing
1. Notify wiki users about the change you'll be making;
2. Create `Widget:LoadSprite` on your wiki. This requires administator
privileges. Copy and paste the contents of `widgets/LoadSprite.txt` in there;
3. Create `Template:LoadSprite` on your wiki. Copy and paste the contents of
`templates/LoadSprite.txt` in there. The template is optional, as previously
stated;
4. Create `MediaWiki:Gadget-spriteDoc.css` on your wiki. This also requires
administrator privileges. Copy and paste the contents of
`css/Gadget-spriteDoc.css` into that page;
5. Create `MediaWiki:Gadget-spriteDoc.js` on you wiki. Copy and paste the
contents of `js/Gadget-spriteDoc.js` into that page;
6. Finally, update `Module:Sprite` with the code in `lua/Sprite.lua`;
7. In `MediaWiki:Gadgets-definition`, add the following line to the page at the
appropiate section: `* spriteDoc[ResourceLoader|default|hidden|dependencies=mediawiki.api,mediawiki.notify,mediawiki.notification,mediawiki.util]|spriteDoc.js|spriteDoc.css`
and remove the following line: `* spriteEditLoader[ResourceLoader|default|dependencies=mediawiki.notification,mediawiki.util]|spriteEditLoader.js`;
8. Go to any page you know that uses the sprite documentation function of the
Lua module (typically `{{#invoke:sprite|doc|<sprite>}}`). Verify that sprite
loading works correctly. Additionally, append `?`/`&spriteaction=edit` to the URL
and verify that sprite loading works correctly and that you can edit any box
if your privileges allow you to edit sprites.

## Post-importing
Once you've verified that all your sprite templates are working correctly, you
can safely delete `MediaWiki:Gadget-spriteEditLoader.js` and `Widget:SpriteDoc.css`.

# Bug reports and questions
Feel free to open a ticket on the [issue tracker](https://github.com/joverwijk/Gadget-spriteDoc/issues).