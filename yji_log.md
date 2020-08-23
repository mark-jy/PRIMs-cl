#### 2020-08-23
revised the edl equation (not complete yet, and still needs to revise spreading to edl-compatible).
thinking for "decay" vs. "interference" debate, and the zero-sum-game of "interference" vs. "base-level decay"
  
(again... only limited to the context-operator learning for now, the next step is mirror that in inter-operator learning)  

#### 2020-08-18
added edl as an alternative to context-op learning 

(note. since there can be infinitely many contexts, the Vtotal term is divided by no.refs, -- or perhaps wrapped around by tanh?)

#### 2020-08-14
added negative learning to "context-out" failedOp overload

#### 2020-08-05
trace declarative chunks

#### 2020-07-29
根据basal ganglia对usable和unusable action同时的强化和负强化机制，需要增加对failed-op和context的负向学习。
因此，需要对previousOperators进行分流
