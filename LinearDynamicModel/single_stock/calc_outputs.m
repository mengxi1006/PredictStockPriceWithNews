clear 
load y_withnews
size_data = size(y_data);
num_col = size_data(2);

for i = 1:num_col
    fit_id_wonews(i) = 1-norm(y_woNews(1:dimIdent,i)-y_data(1:dimIdent,i))/norm(mean(y_data(1:dimIdent,i))-y_data(1:dimIdent,i))
    fit_id_withnews(i) = 1-norm(y_withNews(1:dimIdent,i)-y_data(1:dimIdent,i))/norm(mean(y_data(1:dimIdent,i))-y_data(1:dimIdent,i))
    fit_v_wonews(i) = 1-norm(y_woNews(dimIdent+1:end,i)-y_data(dimIdent+1:end,i))/norm(mean(y_data(dimIdent+1:end,i))-y_data(dimIdent+1:end,i))
    fit_v_withnews(i) = 1-norm(y_withNews(dimIdent+1:end,i)-y_data(dimIdent+1:end,i))/norm(mean(y_data(dimIdent+1:end,i))-y_data(dimIdent+1:end,i))
end