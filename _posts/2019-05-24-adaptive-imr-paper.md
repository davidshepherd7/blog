---
layout: post
title: "Publication: Adaptive-step implicit-midpoint-rule for time integration"
date: 2019-05-24
categories:
---

The main paper from my PhD has finally made it through the publication
process, and is available
[here](https://link.springer.com/article/10.1007/s10915-019-00965-8)
(it's open access so you don't need an expensive subscription to read
it).

The abstract is:

> The implicit mid-point rule is a Runge–Kutta numerical integrator for
> the solution of initial value problems, which possesses important
> properties that are relevant in micromagnetic simulations based on the
> Landau–Lifshitz–Gilbert equation, because it conserves the
> magnetization length and accurately reproduces the energy balance
> (i.e. preserves the geometric properties of the solution). We present
> an adaptive step size version of the integrator by introducing a
> suitable local truncation error estimator in the context of a
> predictor-corrector scheme. We demonstrate on a number of relevant
> examples that the selected step sizes in the adaptive algorithm are
> comparable to the widely used adaptive second-order integrators, such
> as the backward differentiation formula (BDF2) and the trapezoidal
> rule. The proposed algorithm is suitable for a wider class of
> non-linear problems, which are linearised by Newton’s method and
> require the preservation of geometric properties in the numerical
> solution.


In plain English: I took an algorithm which has some useful properties
for simulating magnetic materials and found a way to make it faster
without losing those properties. Hopefully it will turn out to be
useful in other areas of computational physics too, but I didn't have
time to look into that.
