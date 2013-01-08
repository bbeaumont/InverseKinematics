# AS3 Inverse Kinematics 0.1

For 2D inverse kinematics. There are two available solvers:

* FABRIK - see http://www.andreasaristidou.com/publications/CUEDF-INFENG,%20TR-632.pdf
* CCD - see http://www.darwin3d.com/gamedev/articles/col1198.pdf

Note that this is the beginnings of an inverse kinematics library. At the moment it is simply a set of experiments and
does not contain much that is practically useful.

### To do:

* Multiple chains branches.
* Sort out the global/local transforms. It ain't pretty right now.
* 3D.
* Joint limits.
* DOF.
* Optimisations
* Integration with existing bone systems - DragonBones, Away3D etc.