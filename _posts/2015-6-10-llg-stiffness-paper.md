---
layout: post
title:  "Publication: Discretization-Induced Stiffness in Micromagnetic Simulations"
categories:
---

I [published a paper](http://ieeexplore.ieee.org/xpl/login.jsp?arnumber=6971771) a while ago, but I've been pretty busy so hadn't gotten around to figuring out the rules about posting it online. Anyway it looks like I'm allowed to host it on my personal website, so here it is!

The abstract is:

    In the numerical integration of the Landau-Lifshitz-Gilbert
    (LLG) equation, stiffness (stability restrictions on the time step
    size for explicit methods) is known to be a problem in some
    cases. We examine the relationship between stiffness and spatial
    discretisation size for the LLG with exchange and magnetostatic
    effective fields. A maximum stable time step is found for the
    reversal of a single domain spherical nanoparticle with a variety
    of magnetic parameters and numerical methods. From the lack
    of stiffness when solving a physically equivalent ODE problem
    we conclude that any stability restrictions in the PDE case arise
    from the spatial discretisation rather than the underlying physics.
    We find that the discretisation induced stiffness increases as
    the mesh is refined and as the damping parameter is decreased.
    In addition we find that use of the FEM/BEM method for
    magnetostatic calculations increases the stiffness. Finally, we
    observe that the use of explicit magnetostatic calculations within
    an otherwise implicit time integration scheme (i.e. a semi-implicit
    scheme) does not cause stability issues.

In plain English: I investigated when and why one class of algorithms becomes more efficent than another class of algorithms for an important problem in the study of magnetic materials.

Here's the [paper]({{ site.baseurl }}/trans-mag-paper-2014.pdf) itself.

