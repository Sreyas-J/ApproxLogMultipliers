import torch
import torch.nn as nn
import torch.nn.functional as F
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import gaussian_kde


plt.figure(figsize=(10, 8), dpi=150)
ax = plt.gca()
ax.set_facecolor('white')
ax.grid(True, linestyle='-', alpha=0.5)


class SimpleMLPModel(nn.Module):
    def __init__(self, use_adapt=False, axx_mult='mul8s_acc'):
        super(SimpleMLPModel, self).__init__()
        self.fc1 = nn.Linear(784, 128)
        gain = nn.init.calculate_gain('sigmoid')  
        nn.init.xavier_normal_(self.fc1.weight, gain=gain)
        nn.init.zeros_(self.fc1.bias)
        self.bn1 = nn.BatchNorm1d(128)
        self.fc2 = nn.Linear(128, 10)
        nn.init.normal_(self.fc2.weight, mean=0, std=1)
        nn.init.zeros_(self.fc2.bias)
        
    def forward(self, x):
        if x.dim() == 4 or x.dim() == 3:
            x = x.view(-1, 784)
        x = self.fc1(x)
        x = self.bn1(x)
        x = torch.sigmoid(x)
        x = F.dropout(x, p=0.2, training=self.training)
        x = self.fc2(x)
        return F.log_softmax(x, dim=1)


model = SimpleMLPModel()
model.load_state_dict(torch.load('../Weights/mnist_mlp_standard_best.pt', map_location='cpu'))
model.eval()

# Extract and flatten weights
input_hidden_flat = model.fc1.weight.data.cpu().numpy().flatten()
hidden_output_flat = model.fc2.weight.data.cpu().numpy().flatten()

# Quantize to [-127, 127]
def quantize(weights):
    max_val = np.max(np.abs(weights))
    return weights / max_val * 127

quant_input_hidden = quantize(input_hidden_flat)
quant_hidden_output = quantize(hidden_output_flat)

x_points = np.linspace(-150, 150, 1000)

kde_input = gaussian_kde(quant_input_hidden, bw_method=0.15)
density_input = kde_input(x_points)

kde_output = gaussian_kde(quant_hidden_output, bw_method=0.1)  
density_output = kde_output(x_points)

plt.title('Probability distribution of the Trained Weights for the MLP', fontsize=16, fontweight='bold', pad=15)

plt.plot(x_points, density_input, color='gray', linewidth=2, 
         label='Input-to-hidden layer weights')

plt.plot(x_points, density_output, color='black', linewidth=2, 
         linestyle='--', label='Hidden layer-to-output weights')

plt.ylim(0, 0.03)
plt.xlim(-150, 150)

plt.legend(loc='upper right', frameon=True, fontsize=12)

plt.xlabel('Weights Scaled to range [-127, 127]', fontsize=12)
plt.ylabel('Probability', fontsize=12)

plt.tight_layout()
plt.show()