from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/todos', methods=['GET'])
def get_todos():
    return jsonify({"todos": ["Task 1", "Task 2", "Task 3"]})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)