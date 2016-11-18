import os
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.ensemble import RandomForestClassifier
from KaggleWord2VecUtility import KaggleWord2VecUtility
import pandas as pd
import nltk

if __name__ == '__main__':
    #[1] Read the data
    train = pd.read_csv(os.path.join(os.path.dirname('__file__'),'data','C:\\Users\\Darshil\\Documents\\Dhruvi\\BDA\\labeledTrainData.tsv'),header=0,delimiter="\t",quoting=3)
    test = pd.read_csv(os.path.join(os.path.dirname('__file__'),'data','C:\\Users\\Darshil\\Documents\\Dhruvi\\BDA\\testData.tsv'),header=0, delimiter="\t",quoting=3)
    print 'The first review is: \n'
    print train["review"][0]
    raw_input("Press enter to continue")
    
    #[2] Cleaning train dataset
    nltk.download()
    clean_train_reviews=[]
    print 'Cleaning and Parsing the training set...\n'
    for i in xrange(0,len(train["review"])):
        clean_train_reviews.append(" ".join(
                KaggleWord2VecUtility.review_to_wordlist(train["review"][i],True)))
    #[3] Create Bag of words
    print 'Creating bag of words\n'
    vectorizer=CountVectorizer(analyzer="word",max_features=1500,stop_words=None,tokenizer=None)
    train_data_features = vectorizer.fit_transform(clean_train_reviews)
    train_data_features = train_data_features.toarray()
    #[4] Train the classifier
    print 'Training the random forest'
    forest = RandomForestClassifier(n_estimators=100)
    forest= forest.fit(train_data_features,train["sentiment"])
    #[5] Format testing data
    clean_test_reviews=[]
    print 'Cleaning test data set of movie reviews..\n'
    for i in xrange(0,len(test["review"])):
        clean_test_reviews.append(" ".join(
            KaggleWord2VecUtility.review_to_wordlist(test["review"][i],True)))
    test_data_features = vectorizer.fit_transform(clean_test_reviews)
    test_data_features = test_data_features.toarray()
    
    #[6] predict revies in test data
    print 'predicting test label..\n'
    result=forest.predict(test_data_features)
    output=pd.DataFrame( data={"id":test["id"], "sentiment":result} )
    output.to_csv(os.path.join(os.path.dirname('__file__'),
                               'data', 'C:\Users\Darshil\Documents\Dhruvi\BDA\Bag_of_Words_model.csv'), index=False, quoting=3)
    print "Wrote results to Bag_of_Words_model.csv"