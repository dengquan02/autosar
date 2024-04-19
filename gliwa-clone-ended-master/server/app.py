from server.receivers.process_receiver import UdpReceiveProcessManager
from server.receivers.thread_receiver import UdpReceiveThreadManager

from flask import Flask, redirect
from flask_socketio import SocketIO
from flask_cors import CORS
import mimetypes

mimetypes.add_type('text/css', '.css')
mimetypes.add_type('application/javascript', '.js')

app = Flask(
    __name__,
    static_url_path="/statics",
    static_folder=r"D:\study\autosar\gliwa-clone-fronted-master",
)
socketio = SocketIO()
socketio.init_app(app)
CORS(app, supports_credentials=True)

# ############# common tracing

PROCESS_MANAGER = UdpReceiveProcessManager()


@app.route("/")
def tracing_index():
    PROCESS_MANAGER.clear()
    return redirect("/statics/tracing-index.html")


@app.route("/tracing/start")
def tracing_start():
    PROCESS_MANAGER.start()
    return {"message": "OK"}


@app.route("/tracing/stop")
def tracing_stop():
    PROCESS_MANAGER.stop()
    return {"message": "OK"}


@app.route("/tracing/download")
def download():
    return PROCESS_MANAGER.download()


# ############# keep tracing

THREAD_MANAGER = UdpReceiveThreadManager(socketio, min_sec_step=0.25)


@socketio.on('keep-tracing-start')
def keep_tracing_start():
    print("@socketio.on('keep-tracing-start')")
    socketio.start_background_task(lambda: THREAD_MANAGER.start())


@socketio.on('keep-tracing-stop')
def keep_tracing_stop():
    print("@socketio.on('keep-tracing-stop')")
    THREAD_MANAGER.stop()


if __name__ == '__main__':
    app.run()
