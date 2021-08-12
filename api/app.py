import logging

import flask
import python_avatars as pa

logging.getLogger('werkzeug').setLevel(logging.WARN)

app = flask.Flask(__name__)


@app.route('/api/avatar')
def avatar():
    svg = pa.Avatar.random(
        clothing=pa.ClothingType.GRAPHIC_SHIRT,
        clothing_color='#20BA31',
        shirt_graphic=pa.ClothingGraphic.CUSTOM_TEXT,
        shirt_text='Tilt.dev'
    ).render()
    return flask.Response(svg, mimetype='image/svg+xml')


@app.route('/ready')
def ready():
    return flask.Response('', status=204)
