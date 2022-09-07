from flask import Flask, render_template
import random
app = Flask(__name__)
# list of cat images
images = [
"https://executiveponies.files.wordpress.com/2017/03/thriller-cat-edition.gif?w=516&h=413",
"https://executiveponies.files.wordpress.com/2017/03/where-my-phone-where.gif?w=538",
"https://executiveponies.files.wordpress.com/2017/03/whatheckyoudoing.gif?w=500",
"https://executiveponies.files.wordpress.com/2017/03/sooo-bored.gif?w=511",
"https://executiveponies.files.wordpress.com/2017/03/someone-trouble.gif?w=513&h=302",
"https://executiveponies.files.wordpress.com/2017/03/rs_500x250-140630102259-tumblr_inline_msmeewgqs31qz4rgp.gif?w=500",
"https://executiveponies.files.wordpress.com/2017/03/cat_water_drip.gif?w=486",
"https://executiveponies.files.wordpress.com/2017/03/cat-box-runway-model.gif?w=500",
"https://executiveponies.files.wordpress.com/2017/03/cat-slots.gif?w=503",
"https://executiveponies.files.wordpress.com/2017/03/funny-cat-gifs13.gif?w=479",
"https://executiveponies.files.wordpress.com/2017/03/funny-cat-gifs6.gif?w=500",
"https://executiveponies.files.wordpress.com/2017/03/kittens-look.gif?w=1000?w=499"

]
@app.route('/')
def index():
    url = random.choice(images)
    return render_template('index.html', url=url)
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)