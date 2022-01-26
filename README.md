# Towards Safe Reinforcement Learning with a Safety Editor Policy

<p align="center">
    <img src="images/seditor_framework.png" width="500"/>
</p>

This repo releases the code for

> Towards Safe Reinforcement Learning with a Safety Editor Policy, Yu et al., arXiv 2022.

It contains the algorithm and training configuration files reported in the paper.

## What is SEditor?

SEditor is a novel approach that learns two polices (Figure) towards generic safe RL. The utility maximizer (UM) policy is only responsible for maximizing the utility reward without concerning the constraints. Its output actions are potentially unsafe. The safety editor (SE) policy then transforms these actions into safe ones. It is trained to maximize the constraint reward while minimizing a hinge loss of the utility Q values of actions before and after the edit. Both UM and SE are trained in an off-policy manner for good sample efficiency.

## Installation

Our algorithm is based on [Agent Learning Framework (ALF)](https://github.com/HorizonRobotics/alf). Python3.7+ is currently supported by ALF and [Virtualenv](https://virtualenv.pypa.io/en/latest/) is recommended for the installation. After activating a virtual env, download and install ALF:

```bash
git clone https://github.com/HorizonRobotics/alf
cd alf
git checkout origin/seditor_alf -B seditor
pip install -e .
```

On top of the basic ALF installation,

- [MuJoCo](https://mujoco.org/) version 2.1+ has to be first downloaded and set up. Please follow their websites for instructions.

- our customized Safety Gym environment then needs to be installed:

    ```bash
    git clone https://github.com/hnyu/safety-gym.git
    pip install -e safety-gym
    python -c "import safety_gym" # test if correctly installed
    ```

After the installations, clone this repo under ALF:

```bash
cd <ALF_ROOT>/alf/examples/safety
git clone https://github.com/hnyu/seditor
```

## Training SEditor

Training on the Safety Gym tasks:

```bash
cd <ALF_ROOT>/alf/examples
python -m alf.bin.train --root_dir=<TRAIN_JOB_DIR> --conf safety/seditor/seditor_safety_gym_conf.py --conf_param="create_environment.env_name='Safexp-PointGoal1-v0'"
```

where `<TRAIN_JOB_DIR>` is any empty directory for storing the training results. You can replace the value of ``create_environment.env_name`` with any combination ``'Safexp-<ROBOT><TASK><LEVEL>-v0'``, where ``<ROBOT>`` can be either ``Point`` or ``Car``, ``<TASK>`` can be ``Button``, ``Push``, or ``Goal``, and ``<LEVEL>`` can be either ``1`` or ``2``.

Then open the Tensorboard to view the training results

```bash
tensorboard --logdir=<TRAIN_JOB_DIR>
```

Alternatively, training on the safe racing tasks:


```bash
cd <ALF_ROOT>/alf/examples
python -m alf.bin.train --root_dir=<TRAIN_JOB_DIR> --conf safety/seditor/seditor_safe_car_racing_conf.py --conf_param="create_environment.env_name='SafeCarRacing<LEVEL>-v0'"
```

where ``<LEVEL>`` can be either ``0`` or ``1``, representing "SafeRacing" and "SafeRacingObstacle" tasks in the paper, respectively.

## Code reading

The entire SEditor algorithm is implemented in the file [./seditor_algorithm.py], although some basic understanding of ALF is required first.

## Citation
If you use SEditor in the research, please consider citing

```
@article{Yu2022SEditor,
    author={Haonan Yu and Wei Xu and Haichao Zhang},
    title={Towards Safe Reinforcement Learning with a Safety Editor Policy},
    journal={arXiv},
    year={2022}
}
```