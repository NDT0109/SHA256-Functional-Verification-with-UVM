def recover_original_message(input_file, output_file):

    with open(input_file, 'r') as f:
        lines = f.readlines()


    original_messages = []


    for line in lines:
 
        preprocessed_message = ''.join(filter(lambda x: x in '0123456789abcdefABCDEF', line.strip()))

        padding_start = preprocessed_message.rfind('80')
        if padding_start != -1:
         
            original_message_hex = preprocessed_message[:padding_start]
        else:
           
            original_message_hex = preprocessed_message

       
        original_messages.append(original_message_hex)

 
    with open(output_file, 'w') as f:
        for message in original_messages:
            f.write(message + '\n')

    print("Original messages recovered and written to {}".format(output_file))


recover_original_message('message.log', 'message_output.txt')

