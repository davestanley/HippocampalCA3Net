
%load deleteme2
%figure; hist(deleteme2(3000:end,2))
%figure; plot(deleteme2(:,2))
%std(deleteme2(3000:end,2))

# With truncate AP
load deleteme2
index = find(deleteme2(:,2) < -58);
deleteme2 = deleteme2(index,:);
figure; hist(deleteme2(3000:end,2))
figure; plot(deleteme2(:,2))
std(deleteme2(3000:end,2))


