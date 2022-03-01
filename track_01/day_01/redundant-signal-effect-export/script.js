// Define study
const study = lab.util.fromObject({
  "title": "root",
  "type": "lab.flow.Sequence",
  "parameters": {},
  "plugins": [
    {
      "type": "lab.plugins.Metadata",
      "path": undefined
    },
    {
      "type": "lab.plugins.Download",
      "filePrefix": "redundant-signal-effect",
      "path": undefined
    }
  ],
  "metadata": {
    "title": "Redundant Signal Effect",
    "description": "",
    "repository": "",
    "contributors": "Merle Schuckart"
  },
  "files": {},
  "responses": {},
  "content": [
    {
      "type": "lab.html.Page",
      "items": [
        {
          "type": "text",
          "title": "Willkommen zum Experiment",
          "content": "Bevor es losgeht, brauchen wir ein paar Infos von Dir:\n\u003Cbr\u003E \u003Cbr\u003E"
        },
        {
          "required": true,
          "type": "input",
          "label": "Wie heißt deine Lieblings-Filmfigur?",
          "help": "",
          "name": "id"
        },
        {
          "required": true,
          "type": "radio",
          "label": "\u003Cbr\u003EGender reveal! Mit welchem Gender identifizierst du dich am ehesten?",
          "options": [
            {
              "label": "männlich",
              "coding": "male"
            },
            {
              "label": "weiblich",
              "coding": "female"
            },
            {
              "label": "nicht binär",
              "coding": "nb"
            },
            {
              "label": "\u003Cspan style=\"color:grey\"\u003Emöchte nicht antworten\u003C\u002Fspan\u003E",
              "coding": "no_ans"
            }
          ],
          "name": "gender"
        },
        {
          "required": true,
          "type": "input",
          "label": "\u003Cbr\u003EWie alt bist du? ",
          "name": "age",
          "attributes": {
            "type": "number",
            "min": "0",
            "max": "570",
            "step": "1"
          },
          "help": "(Hui sind wir heute indiskret!)"
        }
      ],
      "scrollTop": true,
      "submitButtonText": "Weiter →",
      "submitButtonPosition": "right",
      "files": {},
      "responses": {
        "": ""
      },
      "parameters": {},
      "messageHandlers": {},
      "title": "Hello"
    },
    {
      "type": "lab.html.Page",
      "items": [
        {
          "type": "text",
          "title": "Instruktionen",
          "content": "Das Experiment beginnt gleich.\n\u003Cp\u003E Bitte schau' durchgängig auf das Kreuz in der Mitte des Bildschirms.\u003C\u002Fp\u003E\n\n\u003Cp\u003EDrück' die Leertaste, wenn Du einen Lichtblitz siehst oder einen Ton hörst. Ton und Lichtblitz können einzeln oder gemeinsam auftreten.\u003C\u002Fp\u003E\n\nReagiere bitte so schnell und genau wie möglich."
        }
      ],
      "scrollTop": true,
      "submitButtonText": "Experiment starten →",
      "submitButtonPosition": "right",
      "files": {},
      "responses": {
        "": ""
      },
      "parameters": {},
      "messageHandlers": {},
      "title": "Instructions"
    },
    {
      "type": "lab.canvas.Screen",
      "content": [
        {
          "type": "line",
          "left": "0",
          "top": 0,
          "angle": 0,
          "width": "14",
          "height": 0,
          "stroke": "black",
          "strokeWidth": 1,
          "fill": "rgb(0,0,0)"
        },
        {
          "type": "line",
          "left": 0,
          "top": 0,
          "angle": 90,
          "width": 14,
          "height": 0,
          "stroke": "black",
          "strokeWidth": 1,
          "fill": "rgb(0,0,0)"
        }
      ],
      "viewport": [
        800,
        600
      ],
      "files": {},
      "responses": {
        "": ""
      },
      "parameters": {},
      "messageHandlers": {
        "run": function anonymous(
) {
document.body.style.backgroundColor = "grey"
document.querySelector(".container").style.border = "none"
}
      },
      "title": "Change Background",
      "timeout": "3000"
    },
    {
      "type": "lab.flow.Loop",
      "templateParameters": [
        {
          "condition": "A",
          "aud": 1,
          "vis": "grey"
        },
        {
          "condition": "V",
          "aud": 0,
          "vis": "white"
        },
        {
          "condition": "VA",
          "aud": 1,
          "vis": "white"
        }
      ],
      "sample": {
        "mode": "draw-replace",
        "n": "100"
      },
      "files": {},
      "responses": {
        "": ""
      },
      "parameters": {},
      "messageHandlers": {},
      "title": "Loop",
      "shuffleGroups": [
        [
          "condition",
          "aud",
          "vis"
        ]
      ],
      "template": {
        "type": "lab.canvas.Frame",
        "context": "\u003C!-- Nested components use this canvas --\u003E\n\u003Ccanvas \u002F\u003E",
        "contextSelector": "canvas",
        "files": {},
        "responses": {
          "": ""
        },
        "parameters": {},
        "messageHandlers": {},
        "title": "Frame",
        "content": {
          "type": "lab.flow.Sequence",
          "files": {},
          "responses": {
            "": ""
          },
          "parameters": {},
          "messageHandlers": {},
          "title": "Trial",
          "content": [
            {
              "type": "lab.canvas.Screen",
              "content": [
                {
                  "type": "line",
                  "left": "0",
                  "top": 0,
                  "angle": 0,
                  "width": 14,
                  "height": 0,
                  "stroke": "black",
                  "strokeWidth": 1,
                  "fill": "rgb(0,0,0)"
                },
                {
                  "type": "line",
                  "left": 0,
                  "top": 0,
                  "angle": 90,
                  "width": 14,
                  "height": 0,
                  "stroke": "black",
                  "strokeWidth": 1,
                  "fill": "rgb(0,0,0)"
                }
              ],
              "viewport": [
                800,
                600
              ],
              "files": {},
              "responses": {
                "": ""
              },
              "parameters": {},
              "messageHandlers": {},
              "title": "Fixation",
              "timeout": "${ this.random.range(1500, 2500) }"
            },
            {
              "type": "lab.canvas.Screen",
              "content": [
                {
                  "type": "circle",
                  "left": 0,
                  "top": 75,
                  "angle": 0,
                  "width": 55,
                  "height": 55,
                  "stroke": null,
                  "strokeWidth": 1,
                  "fill": "${parameters.vis}"
                },
                {
                  "type": "line",
                  "left": 0,
                  "top": 0,
                  "angle": 0,
                  "width": "14",
                  "height": 0,
                  "stroke": "black",
                  "strokeWidth": 1,
                  "fill": "rgb(0,0,0)"
                },
                {
                  "type": "line",
                  "left": 0,
                  "top": 0,
                  "angle": "90",
                  "width": 14,
                  "height": 0,
                  "stroke": "black",
                  "strokeWidth": 1,
                  "fill": "rgb(0,0,0)"
                }
              ],
              "viewport": [
                800,
                600
              ],
              "files": {
                "10ms1000Hz.mp3": "embedded\u002Fa00b7241de9dc740f33ad291d838e38d185953ac5b8afcaa2a302e0a4db58030.mp3"
              },
              "responses": {
                "": ""
              },
              "parameters": {},
              "messageHandlers": {
                "before:prepare": function anonymous(
) {
const sound = document.createElement('audio')
sound.src = this.files["10ms1000Hz.mp3"] 
sound.volume = this.aggregateParameters.aud
this.internals.sound = sound
},
                "run": function anonymous(
) {
this.internals.sound.play()
}
              },
              "title": "Stimulus",
              "timeout": "100",
              "timeline": []
            },
            {
              "type": "lab.canvas.Screen",
              "content": [
                {
                  "type": "line",
                  "left": 0,
                  "top": 0,
                  "angle": 0,
                  "width": "14",
                  "height": 0,
                  "stroke": "black",
                  "strokeWidth": 1,
                  "fill": "rgb(0,0,0)"
                },
                {
                  "type": "line",
                  "left": 0,
                  "top": 0,
                  "angle": "90",
                  "width": "14",
                  "height": 0,
                  "stroke": "black",
                  "strokeWidth": 1,
                  "fill": "rgb(0,0,0)"
                }
              ],
              "viewport": [
                800,
                600
              ],
              "files": {},
              "responses": {
                "keydown(Space)": "stim_detected"
              },
              "parameters": {},
              "messageHandlers": {},
              "title": "Reaction",
              "timeout": "1500"
            }
          ]
        }
      }
    },
    {
      "type": "lab.html.Page",
      "items": [
        {
          "type": "text",
          "content": "Vergiss nicht die Daten zu speichern!",
          "title": "Vielen Dank für deine Teilnahme!"
        }
      ],
      "scrollTop": true,
      "submitButtonText": "Daten speichern →",
      "submitButtonPosition": "right",
      "files": {},
      "responses": {
        "": ""
      },
      "parameters": {},
      "messageHandlers": {
        "run": function anonymous(
) {
document.body.style.backgroundColor = "white"
document.querySelector(".container").style.border = "black"
}
      },
      "title": "end"
    }
  ]
})

// Let's go!
study.run()