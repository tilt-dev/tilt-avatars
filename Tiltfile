load('ext://deployment', 'deployment_create')

# version_settings() enforces a minimum Tilt version
# https://docs.tilt.dev/api.html#api.version_settings
version_settings(constraint='>=0.22.2')

config.define_string_list('resources', args=True)
config.define_string('registry', usage="The registry `url` where images are saved")
config.define_string_list('use-latest', usage="Names of `resources` for which Tilt will pull pre-built images from gcr.io ('all' for all resources)")
config.define_bool('push', usage="When present tilt ci will build and push images to gcr.io")
cfg = config.parse()
registry_host = cfg.get('registry', 'gcr.io/windmill-public-containers')
use_latest_all = ['api', 'web']
use_latest = cfg.get('use-latest', [])
use_latest = use_latest_all if use_latest == ['all'] else use_latest
push = cfg.get('push', False)
config.set_enabled_resources(cfg.get('resources', []))

load('deploy/Tiltfile', 'docker_build_with_latest')

# tilt-avatar-api is the backend (Python/Flask app)
# live_update syncs changed source code files to the correct place for the Flask dev server
# and runs pip (python package manager) to update dependencies when changed
# https://docs.tilt.dev/api.html#api.docker_build
# https://docs.tilt.dev/live_update_reference.html
docker_build_with_latest(
    '%s/tilt-avatar-api' % registry_host,
    context='.',
    dockerfile='./deploy/api.dockerfile',
    only=['./api/'],
    live_update=[
        sync('./api/', '/app/api/'),
        run(
            'pip install -r /app/requirements.txt',
            trigger=['./api/requirements.txt']
        )
    ],
    use_latest='api' in use_latest,
    push_images=push
)

# k8s_yaml automatically creates resources in Tilt for the entities
# and will inject any images referenced in the Tiltfile when deploying
# https://docs.tilt.dev/api.html#api.k8s_yaml
# k8s_yaml('deploy/api.yaml')
deployment_create(
    'api',
    '%s/tilt-avatar-api' % registry_host,
    ports='80:5000',
    readiness_probe={'http_get':{'port': 5000,'path': '/ready'}}
)

# k8s_resource allows customization where necessary such as adding port forwards and labels
# https://docs.tilt.dev/api.html#api.k8s_resource
k8s_resource(
    'api',
    port_forwards='5734:5000',
    labels=['backend']
)


# tilt-avatar-web is the frontend (ReactJS/vite app)
# live_update syncs changed source files to the correct place for vite to pick up
# and runs yarn (JS dependency manager) to update dependencies when changed
# if vite.config.js changes, a full rebuild is performed because it cannot be
# changed dynamically at runtime
# https://docs.tilt.dev/api.html#api.docker_build
# https://docs.tilt.dev/live_update_reference.html
docker_build_with_latest(
    '%s/tilt-avatar-web' % registry_host,
    context='.',
    dockerfile='./deploy/web.dockerfile',
    only=['./web/'],
    ignore=['./web/dist/'],
    live_update=[
        fall_back_on('./web/vite.config.js'),
        sync('./web/', '/app/'),
        run(
            'yarn install',
            trigger=['./web/package.json', './web/yarn.lock']
        )
    ],
    use_latest='web' in use_latest,
    push_images=push
)

# k8s_yaml automatically creates resources in Tilt for the entities
# and will inject any images referenced in the Tiltfile when deploying
# https://docs.tilt.dev/api.html#api.k8s_yaml
#k8s_yaml('deploy/web.yaml')
deployment_create(
    'web',
    '%s/tilt-avatar-web' % registry_host,
    ports='3000',
    env=[{'name': 'VITE_CLIENT_PORT', 'value': '5735'}]
)

# k8s_resource allows customization where necessary such as adding port forwards and labels
# https://docs.tilt.dev/api.html#api.k8s_resource
k8s_resource(
    'web',
    port_forwards='5735:3000',
    resource_deps=['api'],
    labels=['frontend']
)

# config.main_path is the absolute path to the Tiltfile being run
# there are many Tilt-specific built-ins for manipulating paths, environment variables, parsing JSON/YAML, and more!
# https://docs.tilt.dev/api.html#modules.config.main_path
tiltfile_path = config.main_path

# print writes messages to the (Tiltfile) log in the Tilt UI
# the Tiltfile language is Starlark, a simplified Python dialect, which includes many useful built-ins
# https://github.com/bazelbuild/starlark/blob/master/spec.md#print
print("""
\033[32m\033[32mHello World from tilt-avatars!\033[0m
    
If this is your first time using Tilt and you'd like some guidance, we've got a tutorial to accompany this project:
    https://docs.tilt.dev/tutorial

If you're feeling particularly adventurous, try opening `{tiltfile}` in an editor and making some changes while Tilt is running.
What happens if you intentionally introduce a syntax error? Can you fix it?
""".format(tiltfile=tiltfile_path))
