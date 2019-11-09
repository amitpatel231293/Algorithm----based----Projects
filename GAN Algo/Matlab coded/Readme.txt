Computer vision
Id: a1697700

The overall process:

Text to videos:
1) Run the DCGan implemented algorithm to get text to images
2) Save image results in imgs folder outside
3) Use Matalab interface to Run Run_Mainfile.m file
4) The video file will be saved with Final_Animation.avi that is final output

There are results already provided Final_Animation.avi and Final_Animation.gif those frames were opted 

Instruction to use pretrained models with DCGan(Thought Vectors)
# Text To Image Synthesis:

Dataset was manually put from MS-COCO and other high quality images with text description on it.

## Requirements
- Python 2.7.6
- [Tensorflow][4]
- [h5py][5]
- [Theano][6] : for skip thought vectors
- [scikit-learn][7] : for skip thought vectors
- [NLTK][8] : for skip thought vectors

## Datasets
- All the steps below for downloading the datasets and models can be performed automatically by running `python download_datasets.py`. Several gigabytes of files will be downloaded and extracted

- The model is currently trained on the [flowers dataset][9]. Download the images from [this link][9] and save them in ```Data/flowers/jpg```. Also download the captions from [this link][10]. Extract the archive, copy the ```text_c10``` folder and paste it in ```Data/flowers```.
- Download the pretrained models and vocabulary for skip thought vectors as per the instructions given [here][13]. Save the downloaded files in ```Data/skipthoughts```.
- Make empty directories in Data, ```Data/samples```,  ```Data/val_samples``` and ```Data/Models```. They will be used for sampling the generated images and saving the trained models.

## Usage
- <b>Data Processing</b> : Extract the skip thought vectors for the flowers data set using :
```
python data_loader.py --data_set="flowers"
```
- <b>Training</b>
  * Basic usage `python train.py --data_set="flowers"`
  * Options
      - `z_dim`: Noise Dimension. Default is 100.
      - `t_dim`: Text feature dimension. Default is 256.
      - `batch_size`: Batch Size. Default is 64.
      - `image_size`: Image dimension. Default is 64.
      - `gf_dim`: Number of conv in the first layer generator. Default is 64.
      - `df_dim`: Number of conv in the first layer discriminator. Default is 64.
      - `gfc_dim`: Dimension of gen untis for for fully connected layer. Default is 1024.
      - `caption_vector_length`: Length of the caption vector. Default is 1024.
      - `data_dir`: Data Directory. Default is `Data/`.
      - `learning_rate`: Learning Rate. Default is 0.0002.
      - `beta1`: Momentum for adam update. Default is 0.5.
      - `epochs`: Max number of epochs. Default is 600.
      - `resume_model`: Resume training from a pretrained model path.
      - `data_set`: Data Set to train on. Default is flowers.
      
- <b>Generating Images from Captions</b>
  * Write the captions in text file, and save it as ```Data/sample_captions.txt```. Generate the skip thought vectors for these captions using:
  ```
  python generate_thought_vectors.py --caption_file="Data/sample_captions.txt"
  ```
  * Generate the Images for the thought vectors using:
  ```
  python generate_images.py --model_path=<path to the trained model> --n_images=8
  ```
   ```n_images``` specifies the number of images to be generated per caption. The generated images will be saved in ```Data/val_samples/```. ```python generate_images.py --help``` for more options.


## Pre-trained Models
- Download the pretrained model from [here][14] and save it in ```Data/Models```. Use this path for generating the images.

## TODO
- Train the model on the MS-COCO data set, and generate more generic images.
