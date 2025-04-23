import torch
import torch.nn as nn
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import rcParams

rcParams['figure.figsize'] = (10, 6)
rcParams['font.family'] = 'serif'
rcParams['font.size'] = 12
rcParams['axes.grid'] = True
rcParams['grid.linestyle'] = '-'
rcParams['grid.alpha'] = 0.3

class StandardAlexNet(nn.Module):
    def __init__(self, num_classes=10):
        super(StandardAlexNet, self).__init__()
        self.features = nn.Sequential(
            nn.Conv2d(3, 64, kernel_size=3, stride=1, padding=1),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=2, stride=2),
            
            nn.Conv2d(64, 192, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=2, stride=2),
            
            nn.Conv2d(192, 384, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            
            nn.Conv2d(384, 256, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            
            nn.Conv2d(256, 256, kernel_size=3, padding=1),
            nn.ReLU(inplace=True),
            nn.MaxPool2d(kernel_size=2, stride=2),
        )
        
        self.classifier = nn.Sequential(
            nn.Dropout(0.5),
            nn.Linear(256 * 4 * 4, 4096),
            nn.ReLU(inplace=True),
            nn.Dropout(0.5),
            nn.Linear(4096, num_classes),
        )
        
        self._initialize_weights()
        
    def _initialize_weights(self):
        for m in self.modules():
            if isinstance(m, nn.Conv2d):
                nn.init.kaiming_normal_(m.weight, mode='fan_out', nonlinearity='relu')
                if m.bias is not None:
                    nn.init.constant_(m.bias, 0)
            elif isinstance(m, nn.Linear):
                nn.init.normal_(m.weight, 0, 0.01)
                nn.init.constant_(m.bias, 0)
    
    def forward(self, x):
        x = self.features(x)
        x = torch.flatten(x, 1)
        x = self.classifier(x)
        return x

model = StandardAlexNet()
try:
    checkpoint = torch.load('../Weights/alexnet_cifar10_best.pt', map_location='cpu')
    model.load_state_dict(checkpoint['model_state_dict'])
    print("Loaded pretrained model")
except Exception as e:
    print(f"Error loading model: {e}")
    print("Using initialized weights")

conv1_weights = model.features[0].weight.data.cpu().numpy().flatten()
conv2_weights = model.features[3].weight.data.cpu().numpy().flatten()
conv3_weights = model.features[6].weight.data.cpu().numpy().flatten()
fc1_weights = model.classifier[1].weight.data.cpu().numpy().flatten()
fc2_weights = model.classifier[4].weight.data.cpu().numpy().flatten()

# Quantize to [-127, 127]
def quantize(weights):
    max_val = np.max(np.abs(weights))
    return np.round(weights / max_val * 127)

quant_conv1 = quantize(conv1_weights)
quant_conv2 = quantize(conv2_weights)
quant_conv3 = quantize(conv3_weights)
quant_fc1 = quantize(fc1_weights)
quant_fc2 = quantize(fc2_weights)

quant_fc_combined = np.concatenate([quant_fc1, quant_fc2])

def calc_histogram(data, bins=300, range=(-150, 150)):
    hist, bin_edges = np.histogram(data, bins=bins, range=range, density=True)
    bin_centers = (bin_edges[:-1] + bin_edges[1:]) / 2
    return bin_centers, hist

bins = 300
x_range = (-150, 150)

x_conv1, y_conv1 = calc_histogram(quant_conv1, bins, x_range)
x_conv2, y_conv2 = calc_histogram(quant_conv2, bins, x_range)
x_conv3, y_conv3 = calc_histogram(quant_conv3, bins, x_range)
x_fc, y_fc = calc_histogram(quant_fc_combined, bins, x_range)

plt.figure(figsize=(10, 8), dpi=150)
ax = plt.gca()

ax.set_facecolor('white')

plt.title('Probability distribution of the trained weights for the AlexNet', fontsize=16, fontweight='bold', pad=15)

plt.plot(x_conv1, y_conv1, 'k:', linewidth=2.0, label='1$^{st}$ Convolution layer')

plt.plot(x_conv2, y_conv2, 'k-', linewidth=1.8, label='2$^{nd}$ Convolution layer')

plt.plot(x_conv3, y_conv3, color='#AAAAAA', linestyle=':', linewidth=2.0, label='3$^{rd}$ Convolution layer')

plt.plot(x_fc, y_fc, color='#666666', linestyle='-', linewidth=1.8, label='1$^{st}$ and 2$^{nd}$ FC layers')

plt.xlabel('Weights scaled to range [-127, 127]', fontsize=14, fontweight='bold')
plt.ylabel('Probability', fontsize=14, fontweight='bold')

ymax = max(y_conv1.max(), y_conv2.max(), y_conv3.max(), y_fc.max())
plt.ylim(0, ymax * 1.1) 
plt.xlim(-150, 150)

plt.grid(True, linestyle='-', alpha=0.5, color="#CCCCCC")

legend = plt.legend(loc='upper right', frameon=True, fontsize=12)
legend.get_frame().set_edgecolor('black')
legend.get_frame().set_linewidth(0.8)
legend.get_frame().set_facecolor('#F8F8F8')  

plt.tick_params(axis='both', colors='black', labelsize=12)

for spine in ax.spines.values():
    spine.set_color('black')
    spine.set_linewidth(1.0)

plt.tight_layout()
plt.show()