######################################################################################
## using pytorch in R via R reticulate

library(reticulate)

## make sure pytorch is installed in your python environment.

## just took this logistic regression example from a pytorch tutorial on
## https://github.com/yunjey/pytorch-tutorial/blob/master/tutorials/02%20-%20Logistic%20Regression/main.py#L35-L42


##### import modules that are needed ################################################
torch      = import("torch")
nn         = import("torch.nn") 
dsets      = import ("torchvision.datasets") 
transforms = import("torchvision.transforms")
Variable   = import( "torch.autograd")$Variable

####### variables need to be carefully set to int, otherwise python won't accept it as float ########
input_size    = 784L
num_classes   = 10L
num_epochs    = 5
batch_size    = 100L
learning_rate = 0.001

####### import data sets ##########################################################################

train_dataset = dsets$MNIST(
  root = 'data', 
  train = TRUE, 
  transform = transforms$ToTensor(),
  download = TRUE
)

test_dataset = dsets$MNIST(
  root = 'data', 
  train = FALSE, 
  transform = transforms$ToTensor()
)

train_loader = torch$utils$data$DataLoader(
  dataset = train_dataset, 
  batch_size = batch_size, 
  shuffle = TRUE
)

test_loader = torch$utils$data$DataLoader(
  dataset = test_dataset, 
  batch_size = batch_size, 
  shuffle = FALSE
)


##### define a LogisticRegressionClass

main = py_run_string(
"
import torch.nn as nn

class LogisticRegression(nn.Module):
  def __init__(self, input_size, num_classes):
    super(LogisticRegression, self).__init__()
    self.linear = nn.Linear(input_size, num_classes)

  def forward(self, x):
    out = self.linear(x)
    return out
")


## in the original python script enumerate was used
## here we enumerate trhough the data with the following construction

py = import_builtins()
py$enumerate

zz = py$enumerate(train_loader)
qq = iterate(zz, simplify = FALSE)

# qq is a list of lists, with an image and a label object, both torch ensor objects
#tmp = qq[[1]]
#tmp = qq[[1]][[2]][[1]]
#images = Variable(tmp$view(-1L,28L*28L))
#tmp  = qq[[1]][[2]][[2]]
#labels = Variable(tmp)

model = main$LogisticRegression(input_size, num_classes)

# Loss and Optimizer
# Softmax is internally computed.
# Set parameters to be updated.

criterion = nn$CrossEntropyLoss()  
optimizer = torch$optim$SGD( model$parameters(), lr = learning_rate)  

for (epoch in 1:num_epochs)
{
  i=0
  for (a in qq)
  {
    i=i+1
    images = Variable(a[[2]][[1]]$view(-1L, 28L*28L))
    labels = Variable(a[[2]][[2]])

    # Forward + Backward + Optimize
    optimizer$zero_grad()
    outputs = model$call(images)
    loss = criterion$call(outputs, labels)
    loss$backward()
    optimizer$step()

    if (i%%100 == 0){
      cat("epoch ");cat(epoch); cat(" / ");cat(num_epochs);
      cat(" step "); cat(i+1)
      cat(" loss: ");cat(loss$data$numpy())
      cat("\n")
      
    }
  }
}


################  test the model on test images ########################################

# Test the Model on test images
correct = 0
total   = 0

zz = py$enumerate(test_loader)
qq = iterate(zz, simplify = FALSE)

for (a in qq){
  images = Variable(a[[2]][[1]]$view(-1L, 28L*28L))
  labels = Variable(a[[2]][[2]])
  outputs = model$call(images)
  predicted = torch$max(outputs$data, 1L)
  correct = correct + 
    sum(  as.vector(predicted[[2]]$numpy()) == labels$data$numpy())
  }

sprintf("Accuracy of the model on the 10000 test images: %f  ", correct/10000)



