# Towards Safe Reinforcement Learning with a Safety Editor Policy

<p align="center">
    <img src="images/seditor_framework.png" width="500"/>
</p>

This repo releases the code for

> Towards Safe Reinforcement Learning with a Safety Editor Policy, Yu et al., arXiv 2022.

It contains the algorithm and training configuration files reported in the paper.

## What is SEditor?

A popular approach in safe RL research is to combine a model-free RL algorithm with the Lagrangian method to adjust the weight of the constraint reward relative to the utility reward dynamically. It relies on a single policy to handle the conflict between utility and constraint rewards, which is often challenging.

SEditor is a two-policy approach that learns a safety editor policy transforming potentially unsafe actions proposed by a utility maximizer policy into safe ones. The safety editor is trained to maximize the constraint reward while minimizing a hinge loss of the utility state-action values before and after an action is edited. SEditor extends existing safety layer designs that assume simplified safety models, to general safe RL scenarios where the safety model can in theory be arbitrarily complex. As a first-order method, it is easy to implement and efficient for both inference and training.

On 12 Safety Gym tasks and 2 safe racing tasks, SEditor demonstrates outstanding utility performance with constraint violation rates as low as once per 2k time steps, even in obstacle-dense environments. On some tasks, this low violation
rate is up to 200 times lower than that of an unconstrained RL method with similar utility performance.

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

And move the file ``seditor_algorithm.py`` under ALF

```bash
cp <ALF_ROOT>/alf/examples/safety/seditor/seditor_algorithm.py <ALF_ROOT>/alf/algorithms/
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

The entire SEditor algorithm is implemented in this [file](./seditor_algorithm.py), and the Lagrangian multiplier method is implemented in ``<ALF_ROOT>/alf/algorithms/lagrangian_reward_weight_algorithm.py``. Some basic understanding of ALF is required to understand the entire pipeline.

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
