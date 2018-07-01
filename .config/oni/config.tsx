import * as React from 'react'
import * as Oni from 'oni-api'

export const activate = (oni: Oni.Plugin.Api) => {
    console.log('config activated')

    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind('<c-enter>', () => console.log('Control+Enter was pressed'))

    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind('<c-p>')

}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log('config deactivated')
}

let colorscheme = 'base16-summerfruit-light';

try {
  const fs = require('fs');
  const configPath = '/Users/asdf/.vimrc_background';
  const data = fs.readFileSync(configPath, 'utf-8').toString('ascii');
  const index = data.indexOf('colorscheme');
  if (index > -1) {
      colorscheme = data.slice(data.indexOf(' ', index) + 1, data.indexOf('\n', index));
  }
} catch (e) {
}

export const configuration = {
    //add custom config here, such as

    'ui.colorscheme': colorscheme,

    //'oni.useDefaultConfig': true,
    //'oni.bookmarks': ['~/Documents'],
    'oni.loadInitVim': true,
    'editor.fontSize': '16px',
    'editor.fontFamily': 'monofur',

    // UI customizations
    'ui.animations.enabled': true,
    'ui.fontSmoothing': 'auto',
}
