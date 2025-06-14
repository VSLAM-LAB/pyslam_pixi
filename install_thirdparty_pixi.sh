#!/usr/bin/env bash
# activate env in the terminal using 'pixi shell'


./install_git_modules.sh

cd cpp
./build.sh

cd ../

cd thirdparty/orbslam2_features
./build.sh
cd ../../

cd thirdparty
git clone --recursive https://gitlab.com/luigifreda/pypangolin.git pangolin        
cd pangolin
git apply ../pangolin.patch
mkdir build   
cd build
cmake .. -DBUILD_PANGOLIN_LIBREALSENSE=OFF -DBUILD_PANGOLIN_LIBREALSENSE2=OFF \
         -DBUILD_PANGOLIN_OPENNI=OFF -DBUILD_PANGOLIN_OPENNI2=OFF \
         -DBUILD_PANGOLIN_FFMPEG=OFF -DBUILD_PANGOLIN_LIBOPENEXR=OFF $EXTERNAL_OPTIONS # disable realsense 
make -j8
cd ..


cd thirdparty
git clone https://github.com/uoip/g2opy.git
cd g2opy
git checkout 5587024
git apply ../g2opy.patch
# need to change python/CMakeLists.txt and replace
#   - LIST(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/EXTERNAL/pybind11/tools)
#   - include_directories(${PROJECT_SOURCE_DIR}/EXTERNAL/pybind11/include)
#   - include(pybind11Tools)
#   + find_package(pybind11 REQUIRED)
mkdir build
cd build
cmake ..
make -j8
cd ../..



# cd thirdparty/pydbow3
cd pydbow3
git apply ../pydbow3.patch
# change CMakeLists.txt to use find_package(pybind11 REQUIRED):
# - add_subdirectory(modules/pybind11)
# + find_package(pybind11 REQUIRED) 
./build.sh
cd ../..

cd thirdparty/pydbow2
git apply ../pydbow2.patch
# change CMakeLists.txt to use find_package(pybind11 REQUIRED):
# - add_subdirectory(modules/pybind11)
# + find_package(pybind11 REQUIRED) 
./build.sh
cd ../..

cd thirdparty/pyibow
git apply ../pyibow.patch
# change CMakeLists.txt to use find_package(pybind11 REQUIRED):
# - add_subdirectory(modules/pybind11)
# + find_package(pybind11 REQUIRED) 
./build.sh
cd ../..



cd thirdparty
git clone https://github.com/borglab/gtsam.git gtsam
cd gtsam
git checkout release/4.2
git apply ../gtsam.patch
cd ../..
# # change install_gtsam.sh to "git checkout 4.2.0" instead of "git checkout tags/4.2a9"
# # change install_gtsam.sh and in GTSAM_OPTIONS add "-DGTSAM_USE_SYSTEM_METIS=ON " before "-DGTSAM_USE_SYSTEM_EIGEN=ON" and "-DGTSAM_ENABLE_BOOST_SERIALIZATION=OFF"
# # change thirdparty/gtsam/gtsam/3rdparty/Spectra/MatOp/internal/ArnoldiOp.h:
# # -    ArnoldiOp<Scalar, OpType, IdentityBOp>(OpType* op, IdentityBOp* /*Bop*/) :
# # +    ArnoldiOp(OpType* op, IdentityBOp* /*Bop*/) :                              # already applied 
./install_gtsam.sh

cd thirdparty/gtsam/build
make python-install # to avoid the error "cannot import name 'gtsam' from partially initialized module 'gtsam' (most likely due to a circular import)"  # https://github.com/borglab/gtsam/issues/1682
cd ../../..

cd thirdparty
git clone https://github.com/apple/ml-depth-pro.git ml_depth_pro
cd ml_depth_pro
git apply ../ml_depth_pro.patch
source get_pretrained_models.sh
cd ../..

cd thirdparty
git clone https://github.com/DepthAnything/Depth-Anything-V2.git depth_anything_v2
cd depth_anything_v2
git apply ../depth_anything_v2.patch
./download_metric_models.py
cd ../..

cd thirdparty
git clone https://github.com/princeton-vl/RAFT-Stereo.git raft_stereo
cd raft_stereo
git apply ../raft_stereo.patch
./download_models.sh
cd ../..

cd thirdparty
git clone https://github.com/megvii-research/CREStereo.git crestereo
cd crestereo
git apply ../crestereo.patch
./download_models.py
cd ../..

cd thirdparty
git clone https://github.com/ibaiGorordo/CREStereo-Pytorch.git crestereo_pytorch
cd crestereo_pytorch
git apply ../crestereo_pytorch.patch
./download_models.py
cd ../..

cd thirdparty
git clone --recursive https://github.com/naver/mast3r mast3r
cd mast3r
git apply ../mast3r.patch
cd dust3r
git apply ../../mast3r-dust3r.patch
cd croco
git apply ../../../mast3r-dust3r-croco.patch
git apply ../../../croco.patch
cd models/curope/
# change kernels.cu:
# -    AT_DISPATCH_FLOATING_TYPES_AND_HALF(tokens.type(), "rope_2d_cuda", ([&] {
# +    AT_DISPATCH_FLOATING_TYPES_AND_HALF(tokens.scalar_type(), "rope_2d_cuda", ([&] {
python setup.py build_ext --inplace
cd ../../../../
mkdir checkpoints
cd checkpoints
wget https://download.europe.naverlabs.com/ComputerVision/MASt3R/MASt3R_ViTLarge_BaseDecoder_512_catmlpdpt_metric.pth
cd ../../../

cd thirdparty
git clone https://github.com/facebookresearch/mvdust3r.git mvdust3r
cd mvdust3r
git checkout 430ca6630b07567cfb2447a4dcee9747b132d5c7
git apply ../mvdust3r.patch
cd croco/models/curope/
python setup.py build_ext --inplace
cd ../../../
mkdir checkpoints
cd checkpoints
wget https://huggingface.co/Zhenggang/MV-DUSt3R/resolve/main/checkpoints/DUSt3R_ViTLarge_BaseDecoder_224_linear.pth
wget https://huggingface.co/Zhenggang/MV-DUSt3R/resolve/main/checkpoints/MVD.pth
wget https://huggingface.co/Zhenggang/MV-DUSt3R/resolve/main/checkpoints/MVDp_s1.pth
wget https://huggingface.co/Zhenggang/MV-DUSt3R/blob/main/checkpoints/MVDp_s2.pth
cd ../../../


# TODO: solve issues with the below dependency for the DepthEstimatorCrestereo
# ./install_megengine.sh


