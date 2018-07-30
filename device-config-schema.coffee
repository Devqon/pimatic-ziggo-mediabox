module.exports = {
  title: "pimatic-ziggo-mediabox device config schemas"
  ZiggoMediaboxRemote: {
    title: "Ziggo remote"
    description: "Ziggo mediabox remote"
    type: "object"
    extensions: ["xLink", "xOnLabel", "xOffLabel"]
    properties:
      buttons:
        description: "The inputs to select from"
        type: "array"
        default: [
          {
            id: "TVPOWER"
          }
          {
            id: "OK"
          }
        ]
        format: "table"
        items:
          type: "object"
          properties:
            id:
              enum: [
                "TVPOWER", "OK"
              ]
              description: "The input ids switchable by the remote"
            text:
              type: "string"
              description: """
                The button text to be displayed. The id will be displayed if not set
              """
              required: false
  }
}