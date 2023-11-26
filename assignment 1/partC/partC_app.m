classdef partC_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        generateButton                 matlab.ui.control.Button
        welcometotheintelligentmosaicgeneratorLabel  matlab.ui.control.Label
        Image                          matlab.ui.control.Image
        pixelsheightEditField          matlab.ui.control.NumericEditField
        pixelsheightEditFieldLabel     matlab.ui.control.Label
        tilesEditField                 matlab.ui.control.NumericEditField
        tilesEditFieldLabel            matlab.ui.control.Label
        pixelswidthEditField           matlab.ui.control.NumericEditField
        pixelswidthEditFieldLabel      matlab.ui.control.Label
        targetimagepathEditField       matlab.ui.control.EditField
        targetimagepathEditFieldLabel  matlab.ui.control.Label
    end

   
    properties (Access = public)
        tiles = 12000; % Description
        pixels = [800,1200];
        target_path = '..\target1.jpg';
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: generateButton
        function generateButtonPushed(app, event)
            value = app.targetimagepathEditField.Value;
            if isempty(value)
                return;
            end
            
            if exist(value,'file') == 0
                app.target_path = '..\target1.jpg';
                return;
            else
                app.target_path = value;
            end
            target_path_todo = app.target_path;
            
            app.generateButton.Enable = "off";
            app.targetimagepathEditField.Enable = 'off';
            app.generateButton.Text = "!!!";
            app.generateButton.BackgroundColor = [0.77 0 0];
            app.generateButton.FontColor = [0 0 0];
            
            if app.tilesEditField.Value > 0
                app.tiles = app.tilesEditField.Value;
            else
                app.tiles = 12000;
            end
            
            tiles_todo = app.tiles;
            
            if app.pixelsheightEditField.Value > 0
                app.pixels(1) = app.pixelsheightEditField.Value;
            else
                app.pixels(1) = 800;
            end
            
          
            
            if app.pixelswidthEditField.Value > 0
                app.pixels(2) = app.pixelswidthEditField.Value;
            else
                app.pixels(2) = 1200;
            end
            
            pixels_todo = app.pixels;
            
            app.welcometotheintelligentmosaicgeneratorLabel.Text = "waiting...";
            app.welcometotheintelligentmosaicgeneratorLabel.BackgroundColor = [0.77 0 0];
            app.welcometotheintelligentmosaicgeneratorLabel.FontColor = [0 0 0];
            pause(1);
           
            
            [mosaic,class] = partC(target_path_todo,tiles_todo,pixels_todo);
            
            imwrite(mosaic,"temp.jpg");
            app.Image.ImageSource = mosaic;
            if class ==1 
                app.welcometotheintelligentmosaicgeneratorLabel.Text = "manmade";
            else
                app.welcometotheintelligentmosaicgeneratorLabel.Text = "natural";
            end
            app.welcometotheintelligentmosaicgeneratorLabel.BackgroundColor = [0.0745 0.6235 1];
            app.welcometotheintelligentmosaicgeneratorLabel.FontColor = [1 1 1];
            
            app.generateButton.BackgroundColor = [0.0745 0.6235 1];
            app.generateButton.FontColor = [1 1 1];
            app.generateButton.Text = "generate";
            app.generateButton.Enable = "on";
            app.targetimagepathEditField.Enable = 'on';
            
        end

        % Value changed function: targetimagepathEditField
        function targetimagepathEditFieldValueChanged(app, event)
            value = app.targetimagepathEditField.Value;
            if exist(value,'file') == 0
                app.targetimagepathEditField.Value = "..\target1.jpg";
                return;
            else
                app.Image.ImageSource = value;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Colormap = [0.2431 0.149 0.6588;0.2431 0.1529 0.6745;0.2471 0.1569 0.6863;0.2471 0.1608 0.698;0.251 0.1647 0.7059;0.251 0.1686 0.7176;1 1 0;0.2549 0.1765 0.7412;0.2588 0.1804 0.749;0.2588 0.1843 0.7608;0.2627 0.1882 0.7725;0.2627 0.1922 0.7843;0.2627 0.1961 0.7922;0.2667 0.2 0.8039;0.2667 0.2039 0.8157;0.2706 0.2078 0.8235;0.2706 0.2157 0.8353;0.2706 0.2196 0.8431;0.2745 0.2235 0.851;0.2745 0.2275 0.8627;0.2745 0.2314 0.8706;0.2745 0.2392 0.8784;0.2784 0.2431 0.8824;0.2784 0.2471 0.8902;0.2784 0.2549 0.898;0.2784 0.2588 0.902;0.2784 0.2667 0.9098;0.2784 0.2706 0.9137;0.2784 0.2745 0.9216;0.2824 0.2824 0.9255;0.2824 0.2863 0.9294;0.2824 0.2941 0.9333;0.2824 0.298 0.9412;0.2824 0.3059 0.9451;0.2824 0.3098 0.949;0.2824 0.3137 0.9529;0.2824 0.3216 0.9569;0.2824 0.3255 0.9608;0.2824 0.3294 0.9647;0.2784 0.3373 0.9686;0.2784 0.3412 0.9686;0.2784 0.349 0.9725;0.2784 0.3529 0.9765;0.2784 0.3569 0.9804;0.2784 0.3647 0.9804;0.2745 0.3686 0.9843;0.2745 0.3765 0.9843;0.2745 0.3804 0.9882;0.2706 0.3843 0.9882;0.2706 0.3922 0.9922;0.2667 0.3961 0.9922;0.2627 0.4039 0.9922;0.2627 0.4078 0.9961;0.2588 0.4157 0.9961;0.2549 0.4196 0.9961;0.251 0.4275 0.9961;0.2471 0.4314 1;0.2431 0.4392 1;0.2353 0.4431 1;0.2314 0.451 1;0.2235 0.4549 1;0.2196 0.4627 0.9961;0.2118 0.4667 0.9961;0.2078 0.4745 0.9922;0.2 0.4784 0.9922;0.1961 0.4863 0.9882;0.1922 0.4902 0.9882;0.1882 0.498 0.9843;0.1843 0.502 0.9804;0.1843 0.5098 0.9804;0.1804 0.5137 0.9765;0.1804 0.5176 0.9725;0.1804 0.5255 0.9725;0.1804 0.5294 0.9686;0.1765 0.5333 0.9647;0.1765 0.5412 0.9608;0.1765 0.5451 0.9569;0.1765 0.549 0.9529;0.1765 0.5569 0.949;0.1725 0.5608 0.9451;0.1725 0.5647 0.9412;0.1686 0.5686 0.9373;0.1647 0.5765 0.9333;0.1608 0.5804 0.9294;0.1569 0.5843 0.9255;0.1529 0.5922 0.9216;0.1529 0.5961 0.9176;0.149 0.6 0.9137;0.149 0.6039 0.9098;0.1451 0.6078 0.9098;0.1451 0.6118 0.9059;0.1412 0.6196 0.902;0.1412 0.6235 0.898;0.1373 0.6275 0.898;0.1373 0.6314 0.8941;0.1333 0.6353 0.8941;0.1294 0.6392 0.8902;0.1255 0.6471 0.8902;0.1216 0.651 0.8863;0.1176 0.6549 0.8824;0.1137 0.6588 0.8824;0.1137 0.6627 0.8784;0.1098 0.6667 0.8745;0.1059 0.6706 0.8706;0.102 0.6745 0.8667;0.098 0.6784 0.8627;0.0902 0.6824 0.8549;0.0863 0.6863 0.851;0.0784 0.6902 0.8471;0.0706 0.6941 0.8392;0.0627 0.698 0.8353;0.0549 0.702 0.8314;0.0431 0.702 0.8235;0.0314 0.7059 0.8196;0.0235 0.7098 0.8118;0.0157 0.7137 0.8078;0.0078 0.7176 0.8;0.0039 0.7176 0.7922;0 0.7216 0.7882;0 0.7255 0.7804;0 0.7294 0.7765;0.0039 0.7294 0.7686;0.0078 0.7333 0.7608;0.0157 0.7333 0.7569;0.0235 0.7373 0.749;0.0353 0.7412 0.7412;0.051 0.7412 0.7373;0.0627 0.7451 0.7294;0.0784 0.7451 0.7216;0.0902 0.749 0.7137;0.102 0.7529 0.7098;0.1137 0.7529 0.702;0.1255 0.7569 0.6941;0.1373 0.7569 0.6863;0.1451 0.7608 0.6824;0.1529 0.7608 0.6745;0.1608 0.7647 0.6667;0.1686 0.7647 0.6588;0.1725 0.7686 0.651;0.1804 0.7686 0.6471;0.1843 0.7725 0.6392;0.1922 0.7725 0.6314;0.1961 0.7765 0.6235;0.2 0.7804 0.6157;0.2078 0.7804 0.6078;0.2118 0.7843 0.6;0.2196 0.7843 0.5882;0.2235 0.7882 0.5804;0.2314 0.7882 0.5725;0.2392 0.7922 0.5647;0.251 0.7922 0.5529;0.2588 0.7922 0.5451;0.2706 0.7961 0.5373;0.2824 0.7961 0.5255;0.2941 0.7961 0.5176;0.3059 0.8 0.5059;0.3176 0.8 0.498;0.3294 0.8 0.4863;0.3412 0.8 0.4784;0.3529 0.8 0.4667;0.3686 0.8039 0.4549;0.3804 0.8039 0.4471;0.3922 0.8039 0.4353;0.4039 0.8039 0.4235;0.4196 0.8039 0.4118;0.4314 0.8039 0.4;0.4471 0.8039 0.3922;0.4627 0.8 0.3804;0.4745 0.8 0.3686;0.4902 0.8 0.3569;0.5059 0.8 0.349;0.5176 0.8 0.3373;0.5333 0.7961 0.3255;0.5451 0.7961 0.3176;0.5608 0.7961 0.3059;0.5765 0.7922 0.2941;0.5882 0.7922 0.2824;0.6039 0.7882 0.2745;0.6157 0.7882 0.2627;0.6314 0.7843 0.251;0.6431 0.7843 0.2431;0.6549 0.7804 0.2314;0.6706 0.7804 0.2235;0.6824 0.7765 0.2157;0.698 0.7765 0.2078;0.7098 0.7725 0.2;0.7216 0.7686 0.1922;0.7333 0.7686 0.1843;0.7451 0.7647 0.1765;0.7608 0.7647 0.1725;0.7725 0.7608 0.1647;0.7843 0.7569 0.1608;0.7961 0.7569 0.1569;0.8078 0.7529 0.1529;0.8157 0.749 0.1529;0.8275 0.749 0.1529;0.8392 0.7451 0.1529;0.851 0.7451 0.1569;0.8588 0.7412 0.1569;0.8706 0.7373 0.1608;0.8824 0.7373 0.1647;0.8902 0.7373 0.1686;0.902 0.7333 0.1765;0.9098 0.7333 0.1804;0.9176 0.7294 0.1882;0.9255 0.7294 0.1961;0.9373 0.7294 0.2078;0.9451 0.7294 0.2157;0.9529 0.7294 0.2235;0.9608 0.7294 0.2314;0.9686 0.7294 0.2392;0.9765 0.7294 0.2431;0.9843 0.7333 0.2431;0.9882 0.7373 0.2431;0.9961 0.7412 0.2392;0.9961 0.7451 0.2353;0.9961 0.7529 0.2314;0.9961 0.7569 0.2275;0.9961 0.7608 0.2235;0.9961 0.7686 0.2196;0.9961 0.7725 0.2157;0.9961 0.7804 0.2078;0.9961 0.7843 0.2039;0.9961 0.7922 0.2;0.9922 0.7961 0.1961;0.9922 0.8039 0.1922;0.9922 0.8078 0.1922;0.9882 0.8157 0.1882;0.9843 0.8235 0.1843;0.9843 0.8275 0.1804;0.9804 0.8353 0.1804;0.9765 0.8392 0.1765;0.9765 0.8471 0.1725;0.9725 0.851 0.1686;0.9686 0.8588 0.1647;0.9686 0.8667 0.1647;0.9647 0.8706 0.1608;0.9647 0.8784 0.1569;0.9608 0.8824 0.1569;0.9608 0.8902 0.1529;0.9608 0.898 0.149;0.9608 0.902 0.149;0.9608 0.9098 0.1451;0.9608 0.9137 0.1412;0.9608 0.9216 0.1373;0.9608 0.9255 0.1333;0.9608 0.9333 0.1294;0.9647 0.9373 0.1255;0.9647 0.9451 0.1216;0.9647 0.949 0.1176;0.9686 0.9569 0.1098;0.9686 0.9608 0.1059;0.9725 0.9686 0.102;0.9725 0.9725 0.0941;0.9765 0.9765 0.0863;0.9765 0.9843 0.0824];
            app.UIFigure.Position = [100 100 611 527];
            app.UIFigure.Name = 'MATLAB App';

            % Create targetimagepathEditFieldLabel
            app.targetimagepathEditFieldLabel = uilabel(app.UIFigure);
            app.targetimagepathEditFieldLabel.HorizontalAlignment = 'right';
            app.targetimagepathEditFieldLabel.Position = [110 476 113 22];
            app.targetimagepathEditFieldLabel.Text = 'target image path';

            % Create targetimagepathEditField
            app.targetimagepathEditField = uieditfield(app.UIFigure, 'text');
            app.targetimagepathEditField.ValueChangedFcn = createCallbackFcn(app, @targetimagepathEditFieldValueChanged, true);
            app.targetimagepathEditField.HorizontalAlignment = 'center';
            app.targetimagepathEditField.Position = [257 466 160 42];
            app.targetimagepathEditField.Value = '..\target1.jpg';

            % Create pixelswidthEditFieldLabel
            app.pixelswidthEditFieldLabel = uilabel(app.UIFigure);
            app.pixelswidthEditFieldLabel.HorizontalAlignment = 'right';
            app.pixelswidthEditFieldLabel.Position = [156 379 70 22];
            app.pixelswidthEditFieldLabel.Text = 'pixels width';

            % Create pixelswidthEditField
            app.pixelswidthEditField = uieditfield(app.UIFigure, 'numeric');
            app.pixelswidthEditField.Position = [257 379 83 23];
            app.pixelswidthEditField.Value = 1200;

            % Create tilesEditFieldLabel
            app.tilesEditFieldLabel = uilabel(app.UIFigure);
            app.tilesEditFieldLabel.HorizontalAlignment = 'right';
            app.tilesEditFieldLabel.Position = [196 425 27 22];
            app.tilesEditFieldLabel.Text = 'tiles';

            % Create tilesEditField
            app.tilesEditField = uieditfield(app.UIFigure, 'numeric');
            app.tilesEditField.HorizontalAlignment = 'center';
            app.tilesEditField.Position = [257 417 160 38];
            app.tilesEditField.Value = 12000;

            % Create pixelsheightEditFieldLabel
            app.pixelsheightEditFieldLabel = uilabel(app.UIFigure);
            app.pixelsheightEditFieldLabel.HorizontalAlignment = 'right';
            app.pixelsheightEditFieldLabel.Position = [144 342 83 22];
            app.pixelsheightEditFieldLabel.Text = 'pixels height';

            % Create pixelsheightEditField
            app.pixelsheightEditField = uieditfield(app.UIFigure, 'numeric');
            app.pixelsheightEditField.Position = [257 341 84 24];
            app.pixelsheightEditField.Value = 800;

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.BackgroundColor = [0 0 0];
            app.Image.Position = [96 82 420 240];
            app.Image.ImageSource = 'target1.jpg';

            % Create welcometotheintelligentmosaicgeneratorLabel
            app.welcometotheintelligentmosaicgeneratorLabel = uilabel(app.UIFigure);
            app.welcometotheintelligentmosaicgeneratorLabel.BackgroundColor = [0.0745 0.6235 1];
            app.welcometotheintelligentmosaicgeneratorLabel.HorizontalAlignment = 'center';
            app.welcometotheintelligentmosaicgeneratorLabel.FontWeight = 'bold';
            app.welcometotheintelligentmosaicgeneratorLabel.FontAngle = 'italic';
            app.welcometotheintelligentmosaicgeneratorLabel.FontColor = [1 1 1];
            app.welcometotheintelligentmosaicgeneratorLabel.Position = [97 30 420 33];
            app.welcometotheintelligentmosaicgeneratorLabel.Text = 'welcome to the intelligent mosaic generator';

            % Create generateButton
            app.generateButton = uibutton(app.UIFigure, 'push');
            app.generateButton.ButtonPushedFcn = createCallbackFcn(app, @generateButtonPushed, true);
            app.generateButton.BackgroundColor = [0.0745 0.6235 1];
            app.generateButton.FontWeight = 'bold';
            app.generateButton.FontColor = [1 1 1];
            app.generateButton.Position = [348 342 69 60];
            app.generateButton.Text = 'generate';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = partC_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end