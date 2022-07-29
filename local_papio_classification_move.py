# Jugal Patel
# Classification Tree of Movement Behaviour Selection Functions
# Email: jugal.patel@mcgill.ca
# 08/2019

# Problem: simulate animal movement based on expected behaviour across heterogeneous (environmental) feature space
# Solution: extract rules from path segmentation labelled movement data (to implement into an ABM) using classification

# ----
import pandas as pd
import pydotplus
from sklearn.externals.six import StringIO
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz
from sklearn import metrics
from sklearn.metrics import classification_report, confusion_matrix

# Import data representing troop movements
dataset = pd.read_csv("moving.csv")  # moving.csv contains movement and null points
print("moving data imported")

# Pre-process for classification tree : movement behaviour space or no
# Convert data into pandas dataframe
move = pd.DataFrame(dataset,
                    index=None)

if isinstance(move, pd.DataFrame):
    print("dataframe constructed")
else:
    print("dataframe construction error -- halting")

# Determine shape of dataframe
print("shape (r, c):", move.shape)
print(move.head())

# Dimensions in dataframe
print("there are ", move.ndim, " dimensions in our dataframe")

# Retain only deployID and feature distances
move = move[['deployID', 'tree', 'treegroup', 'trail', 'clearing', 'river']]

# Split data based on it being an explanatory or response variable
X = move[['tree', 'treegroup', 'trail', 'clearing', 'river']]
Y = move[['deployID']]

# Split data into training:testing:validation datasets (70:20:10)
seed = 0

X_train, X_validation, Y_train, Y_validation = train_test_split(X, Y, test_size=0.10, random_state=seed)
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.18, random_state=seed)  # 18 % == 20 % of total

print("data split into training:testing:validation sets. Seed used:", seed)

# Features:
print("X training shape (r, c):", X_train.shape)
print(X_train.head())

print("X testing shape (r, c):", X_test.shape)
print(X_test.head())

print("X validation shape (r, c):", X_validation.shape)
print(X_validation.head())

# Labels:
print("Y training shape (r, c):", Y_train.shape)
print(Y_train.head())

print("Y testing shape (r, c):", Y_test.shape)
print(Y_test.head())

print("Y validation shape (r, c):", Y_validation.shape)
print(Y_validation.head())

# Classification tree : movement behaviour space or no
classify_move = DecisionTreeClassifier(criterion='gini', min_impurity_decrease=1e-7, max_depth=5)
classify_move.fit(X_train, Y_train)
print("training complete")

# Tree output and metrics
Y_pred = classify_move.predict(X_test)

print(confusion_matrix(Y_test, Y_pred))
print(classification_report(Y_test, Y_pred))

dot_data = StringIO()

export_graphviz(classify_move,
                out_file=dot_data,
                filled=True,
                rounded=True,
                special_characters=True)

graph = pydotplus.graph_from_dot_data(dot_data.getvalue())
graph.write_pdf("classify_move.pdf")
print("movement classification tree finished")

# Calculate classification accuracy
print("Classification Accuracy:", metrics.accuracy_score(Y_test, Y_pred))

# Feature importance
print(classify_move.feature_importances_)

# Extracting cells of confusion matrix
confusion = metrics.confusion_matrix(Y_test, Y_pred)
TP = confusion[1, 1]  # true positive when predicted 1, labelled as 1
TN = confusion[0, 0]  # true negative when predicted 0, labelled as 0
FP = confusion[0, 1]  # false positive when predicted 1, labelled as 0
FN = confusion[1, 0]  # false negative when predicted 0, labelled as 1
print(confusion_matrix(Y_test, Y_pred))
print(TP, TN, FP, FN)

# Classification accuracy another way
print("Classification Accuracy:", (TP + TN) / float(TP + TN + FP + FN))

# Classification error
print("Classification Error:", (FP + FN) / float(TP + TN + FP + FN))

# Calculate sensitivity; how well can the classifier detect 1; aka Recall or True Positive Rate
print("Sensitivity:", TP / float(TP + FN))
print(metrics.recall_score(Y_test, Y_pred))

# ----
