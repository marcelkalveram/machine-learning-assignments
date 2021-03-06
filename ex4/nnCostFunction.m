function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

# Forward propagation

% 5000x10
y_matrix = eye(num_labels)(y,:);

% 5000x401
a1 = [ones(m, 1) X];

% 5000x25
z2 = a1 * Theta1';
a2 = sigmoid(z2);

% 5000x26
a2 = [ones(size(a2, 1), 1) a2];

% 5000x10
z3 = a2 * Theta2';
a3 = sigmoid(z3);

J = 1 / m * sum(sum(( - y_matrix .* log(a3)) - (( 1 - y_matrix) .* log(1-a3))));

% regularization
regularization = (lambda / (2 * m)) * (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)));
J = J + regularization;

% 5000x10
d3 = a3 - y_matrix;

% 5000x10 * 10x25 = 5000x25
sigmoidGradient_z2 = sigmoidGradient(z2); % 5000x25
d2 = d3 * Theta2(:,2:end) .* sigmoidGradient_z2;

% 25x5000 * 5000x401 = 25x401
Delta1 = d2' * a1;

% 10x5000 * 5000x26 = 10x26
Delta2 = d3' * a2;

Theta1_grad_unregularized = Delta1/m;
Theta2_grad_unregularized = Delta2/m;

Theta1(:,1) = 0;
Theta2(:,1) = 0;

Theta1_grad = Theta1_grad_unregularized + (Theta1 ./m .* lambda);
Theta2_grad = Theta2_grad_unregularized + (Theta2 ./m .* lambda);

% calculate cost
% for k = 1:num_labels
    % 1x5000 * 5000x10
    % = 1x10
% end

% X = [ones(m, 1) X];

% JK = zeros(10,1);

% % 5000x401 * 401x25
% a1 = X * Theta1';
% a1 = sigmoid(a1);
% % = 5000x25

% n = size(a1, 1);
% a1 = [ones(n, 1) a1];

% % 5000x26 * 26x10
% a2 = a1 * Theta2';
% a2 = sigmoid(a2);
% % = 5000x10

% % 5000x10
% delta_L = zeros(m, num_labels);

% % calculate cost
% for k = 1:num_labels

%     % 5000x1 - 5000x1
%     delta_L(:,k) = a2(:,k) - (y == k);
%     % = 5000x10

%     % 1x5000 * 5000x10
%     JK(k) = 1 / m * (( - (y == k)' * log(a2)) - (( 1 - (y == k))' * log(1-a2)))(k);
%     % = 1x10
% end

% % (26x10 * 10x5000)
% delta_L_minus_1 = (Theta2' * delta_L) .* 
% % 26x5000

% J = sum(sum(JK)) / 10;
















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
