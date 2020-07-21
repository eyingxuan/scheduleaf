import nltk

nltk.download("vader_lexicon")
from nltk.sentiment.vader import SentimentIntensityAnalyzer

analyzer = None


def create_analyzer():
    global analyzer
    analyzer = SentimentIntensityAnalyzer()


def get_analyzer():
    return analyzer
