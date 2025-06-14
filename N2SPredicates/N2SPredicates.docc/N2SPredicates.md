# ``N2SPredicates``

This is a really dumb dependency. 
We wrap some predicate generator here, and use Swift5 to build it since Predicate doesn't work well with Swift6. There's a Sendable problem on ``KeyPath``, the non-sendability of ``KeyPath`` conflicts with Swift6's concurrency check.

## Overview

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
